import asyncio
import websockets
import sounddevice as sd

async def send_audio(ws):
    """Send audio data to WebSocket server."""
    loop = asyncio.get_event_loop()
    input_queue = asyncio.Queue()

    def audio_callback(indata, frames, time, status):
        loop.call_soon_threadsafe(input_queue.put_nowait, indata.tobytes())

    # Record audio stream
    stream = sd.InputStream(
        channels=1,
        samplerate=16000,
        dtype='int16',
        callback=audio_callback,
        blocksize=1024
    )

    # Send audio stream to the server
    with stream:
        while True:
            indata = await input_queue.get()
            await ws.send(indata)

async def receive_transcriptions(ws):
    """Receive transcriptions from WebSocket server."""
    async for message in ws:
        print(f"{message}")

async def test_websocket():
    uri = "ws://localhost:8000/TranscribeStreaming"
    async with websockets.connect(uri) as ws:

        send_task = asyncio.create_task(send_audio(ws))
        receive_task = asyncio.create_task(receive_transcriptions(ws))

        # Simulate user clicking a "submit" button after a period of recording
        await asyncio.sleep(300)  # Record for 5 minutes
        await ws.send("submit_response")
        send_task.cancel()  # Stop sending audio data

        await asyncio.gather(send_task, receive_task, return_exceptions=True)
        await receive_task  # Ensure all messages are received
        # Close the websocket connection after processing
        await ws.close()

if __name__ == "__main__":
    asyncio.run(test_websocket())
