from flask import Flask, render_template, request, jsonify
from chatbot import ContextAwareChatbot

app = Flask(__name__)
chatbot = ContextAwareChatbot()

@app.route('/')
def index():
    """
    Render the main chat interface
    """
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    """
    Handle chat requests and return AI responses
    """
    user_message = request.json.get('message', '')
    
    if not user_message:
        return jsonify({"error": "No message provided"}), 400
    
    try:
        response = chatbot.get_response(user_message)
        return jsonify({
            "response": response["response"],
            "summary": response["summary"]
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/end_session', methods=['DELETE'])
def end_session():
    """
    End the current chat session and clear conversation history
    """
    try:
        chatbot.clear_conversation_history()
        return jsonify({"status": "Session ended successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)