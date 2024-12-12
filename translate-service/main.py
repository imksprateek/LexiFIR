from flask import Flask, request, jsonify
import boto3
from botocore.exceptions import BotoCoreError, ClientError

# Initialize the Flask application
app = Flask(__name__)

# AWS Translate client
translate_client = boto3.client('translate', region_name='us-east-1')

@app.route('/translate', methods=['POST'])
def translate():
    try:
        # Parse the request data
        data = request.get_json()
        if not data or 'text' not in data or 'target_language' not in data:
            return jsonify({"error": "Invalid request payload."}), 400

        text = data['text']
        target_language = data['target_language']

        # Determine source language automatically
        response = translate_client.translate_text(
            Text=text,
            SourceLanguageCode='auto',  # Automatically detect source language
            TargetLanguageCode=target_language
        )

        return jsonify({
            "source_language": response.get('SourceLanguageCode'),
            "translated_text": response.get('TranslatedText')
        })

    except (BotoCoreError, ClientError) as error:
        return jsonify({"error": str(error)}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Run the Flask server on port 5000
    app.run(host='0.0.0.0', port=5000, debug=True)
