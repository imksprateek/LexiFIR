import asyncio
import os
import logging
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from amazon_transcribe.client import TranscribeStreamingClient
from amazon_transcribe.handlers import TranscriptResultStreamHandler
from amazon_transcribe.model import TranscriptEvent

app = FastAPI()

@app.websocket("/TranscribeStreaming")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    websocket_open = True
    stop_audio_stream = False  # Flag to indicate when to stop the audio stream
    audio_queue = asyncio.Queue()  # Queue for incoming audio data

    class MyEventHandler(TranscriptResultStreamHandler):
        def __init__(self, output_stream, websocket):
            super().__init__(output_stream)
            self.websocket = websocket
            self.final_transcript = ""

        async def handle_transcript_event(self, transcript_event: TranscriptEvent):
            if websocket_open:  # Check WebSocket state
                results = transcript_event.transcript.results
                for result in results:
                    if result.is_partial:
                        continue
                    for alt in result.alternatives:
                        print(alt.transcript)
                        self.final_transcript += alt.transcript + " "
                        await self.websocket.send_text(alt.transcript)

        async def send_final_transcript(self):
            if websocket_open:  # Check WebSocket state
                await self.websocket.send_text(f"Final Transcript: {self.final_transcript.strip()}")

    async def mic_stream():
        while True:
            indata = await audio_queue.get()
            if stop_audio_stream:
                break
            yield indata, None

    async def write_chunks(stream):
        async for chunk, _ in mic_stream():
            try:
                await stream.input_stream.send_audio_event(audio_chunk=chunk)
            except OSError as e:
                logging.error(f"OSError: {e}")
                break
        await stream.input_stream.end_stream()

    handler = None  # Initialize handler

    try:
        region = os.getenv("AWS_REGION", "us-east-1")

        client = TranscribeStreamingClient(region=region)

        stream = await client.start_stream_transcription(
            language_code="en-IN",
            media_sample_rate_hz=16000,
            media_encoding="pcm",
        )

        handler = MyEventHandler(stream.output_stream, websocket)
        send_task = asyncio.create_task(write_chunks(stream))
        handle_task = asyncio.create_task(handler.handle_events())

        while True:
            message = await websocket.receive()
            if message["type"] == "websocket.receive":
                if "bytes" in message:
                    audio_chunk = message["bytes"]
                    await audio_queue.put(audio_chunk)
                elif "text" in message:
                    text_message = message["text"]
                    logging.info(f"Received message: {text_message}")  # Log received message
                    if text_message == "submit_response":
                        print("received:", "submit_response")
                        stop_audio_stream = True  # Signal to stop the audio stream
                        await send_task  # Wait for the audio stream to finish gracefully
                        break

        await handler.send_final_transcript()

    except WebSocketDisconnect:
        logging.info("WebSocket disconnected")
    except Exception as e:
        logging.error(f"Unexpected error: {e}")

    finally:
        websocket_open = False  # Update WebSocket state
        if handler:
            await handler.send_final_transcript()  # Ensure final transcript is sent in all cases
        await websocket.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, ws_ping_interval=None)
