import os
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder
from sklearn.multiclass import OneVsRestClassifier
from sklearn.svm import LinearSVC
from sklearn.metrics import classification_report
import re

from flask import Flask, request, jsonify

class IPCSectionClassifier:
    def __init__(self):
        self.vectorizer = TfidfVectorizer(stop_words='english', max_features=5000)
        self.label_encoder = LabelEncoder()
        self.classifier = OneVsRestClassifier(LinearSVC(random_state=42))
        self.data = None  # Placeholder for the full dataset

    def preprocess_text(self, text):
        if not isinstance(text, str):
            text = str(text)  # Convert non-string values to string
        # Convert to lowercase
        text = text.lower()
        # Remove special characters and digits
        text = re.sub(r'[^a-zA-Z\s]', '', text)
        # Remove extra whitespaces
        text = ' '.join(text.split())
        return text

    def prepare_data(self, data):
        # Preprocess descriptions
        data['processed_description'] = data['Description'].apply(self.preprocess_text)

        # Encode labels
        data['encoded_section'] = self.label_encoder.fit_transform(data['Section'])

        self.data = data  # Store the dataset for later reference
        return data

    def train(self, data):
        # Prepare data
        processed_data = self.prepare_data(data)

        # Vectorize descriptions
        X = self.vectorizer.fit_transform(processed_data['processed_description'])
        y = processed_data['encoded_section']

        # Split data
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Train classifier
        self.classifier.fit(X_train, y_train)

        # Evaluate
        y_pred = self.classifier.predict(X_test)

        # Get unique labels in y_test and y_pred
        unique_labels = np.unique(np.concatenate((y_test, y_pred)))

        # Filter target_names to match the unique labels
        target_names = [self.label_encoder.classes_[i] for i in unique_labels]

        print("\nClassification Report:\n", classification_report(y_test, y_pred,
              target_names=target_names))  # Use filtered target_names

        return self

    def predict(self, description):
        # Preprocess input
        processed_desc = self.preprocess_text(description)

        # Vectorize
        desc_vectorized = self.vectorizer.transform([processed_desc])

        # Predict
        prediction = self.classifier.predict(desc_vectorized)
        predicted_section = self.label_encoder.inverse_transform(prediction)[0]

        # Retrieve additional details
        details = self.data[self.data['Section'] == predicted_section].iloc[0]
        return {
            "Section": predicted_section,
            "Offense": details['Offense'],
            "Punishment": details['Punishment'],
            "Scenario": details['Scenario'],
            # "Related Cases": details.get('Related Cases', "No related cases available"),
            # "Judgments Summary": details.get('Judgments Summary', "No judgment summary available"),
            # "Additional Notes": details.get('Additional Notes', "No additional notes available")
        }

    def get_top_predictions(self, description, top_k=3):
        # Preprocess input
        processed_desc = self.preprocess_text(description)

        # Vectorize
        desc_vectorized = self.vectorizer.transform([processed_desc])

        # Get decision function scores
        decision_scores = self.classifier.decision_function(desc_vectorized)[0]

        # Get top k indices
        top_k_indices = decision_scores.argsort()[-top_k:][::-1]

        # Get top k sections and their scores
        top_sections = self.label_encoder.inverse_transform(top_k_indices)
        top_scores = decision_scores[top_k_indices]

        # Normalize scores to 0-100 range
        def normalize_score(score):
            # Use sigmoid-like transformation to convert to 0-100 range
            normalized = 50 + 50 * (score / (abs(score) + 1))
            return round(normalized, 2)

        # Retrieve additional details for top predictions
        top_predictions = []
        for section, score in zip(top_sections, top_scores):
            details = self.data[self.data['Section'] == section].iloc[0]
            top_predictions.append({
                "Section": section,
                "Offense": details['Offense'],
                "Punishment": details['Punishment'],
                "Scenario": details['Scenario'],
                "Confidence Score": normalize_score(score),
                # "Related Cases": details.get('Related Cases', "No related cases available"),
                # "Judgments Summary": details.get('Judgments Summary', "No judgment summary available"),
                # "Additional Notes": details.get('Additional Notes', "No additional notes available")
            })

        return top_predictions

# Initialize Flask app and classifier
app = Flask(__name__)

# Global classifier instance
global_classifier = None

@app.route('/predict', methods=['POST'])
def predict():
    global global_classifier
    
    # Check if classifier is initialized
    if not global_classifier:
        return jsonify({"error": "Classifier not initialized"}), 500

    # Get description from JSON request
    data = request.get_json()
    
    # Validate input
    if not data or 'description' not in data:
        return jsonify({"error": "No description provided"}), 400

    description = data['description']

    try:
        # Get main prediction
        prediction = global_classifier.predict(description)
        
        # Get top predictions
        top_predictions = global_classifier.get_top_predictions(description)

        return jsonify({
            "main_prediction": prediction,
            "top_predictions": top_predictions
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

def initialize_classifier():
    global global_classifier
    
    # Determine the path to the CSV file
    script_dir = os.path.dirname(os.path.abspath(__file__))
    csv_path = os.path.join(script_dir, 'ipc_sections_with_judgments (1).csv')

    # Check if the file exists
    if not os.path.exists(csv_path):
        print(f"Error: CSV file not found at {csv_path}")
        return None

    # Load data
    data = pd.read_csv(csv_path)

    # Initialize and train the classifier
    global_classifier = IPCSectionClassifier()
    global_classifier.train(data)

    return global_classifier

def main():
    # Initialize the classifier
    classifier = initialize_classifier()
    
    if classifier:
        # Run the Flask app
        app.run(debug=True, host='0.0.0.0', port=5000)
    else:
        print("Failed to initialize classifier. Check the CSV file.")

if __name__ == "__main__":
    main()