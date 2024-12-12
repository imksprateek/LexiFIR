import os
import uuid
import torch
import PyPDF2
import docx
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from typing import List, Dict, Any
import pandas as pd

# RAG and ML Imports
from groq import Groq
from sentence_transformers import SentenceTransformer
import chromadb
from chromadb.config import Settings
import numpy as np

class ContextAwareRAGSystem:
    def __init__(self, 
                 groq_api_key: str, 
                 embedding_model: str = 'sentence-transformers/all-MiniLM-L6-v2',
                 llm_model: str = 'llama-3.1-70b-versatile'):
        """
        Initialize the RAG system with context tracking capabilities
        """
        # Initialize Groq client
        self.groq_client = Groq(api_key=groq_api_key)
        
        # Initialize ChromaDB client
        chroma_path = os.path.join(os.getcwd(), "chroma_storage")
        os.makedirs(chroma_path, exist_ok=True)
        
        self.chroma_client = chromadb.PersistentClient(path=chroma_path)
        
        # Create a collection for document embeddings
        self.collection = self.chroma_client.get_or_create_collection(
            name="document_collection",
            metadata={"hnsw:space": "cosine"}
        )
        
        # Initialize embedding model
        self.embedding_model = SentenceTransformer(embedding_model)
        
        # LLM model for generation
        self.llm_model = llm_model
        
        # Context storage
        self.conversation_context: List[Dict[str, Any]] = []
        
        # File context storage
        self.file_contexts: Dict[str, Dict] = {}
    
    def extract_text_from_file(self, file_path: str) -> str:
        """
        Extract text from various file types
        
        Args:
            file_path (str): Path to the uploaded file
        
        Returns:
            str: Extracted text content
        """
        file_ext = os.path.splitext(file_path)[1].lower()
        
        try:
            if file_ext == '.pdf':
                # PDF file extraction
                with open(file_path, 'rb') as file:
                    reader = PyPDF2.PdfReader(file)
                    text = ' '.join([page.extract_text() for page in reader.pages])
                    return text
            
            elif file_ext == '.docx':
                # Word document extraction
                doc = docx.Document(file_path)
                text = ' '.join([para.text for para in doc.paragraphs])
                return text
            
            elif file_ext == '.txt':
                # Plain text file
                with open(file_path, 'r', encoding='utf-8') as file:
                    return file.read()
            
            elif file_ext in ['.csv', '.xlsx']:
                # Excel or CSV file
                if file_ext == '.csv':
                    df = pd.read_csv(file_path)
                else:
                    df = pd.read_excel(file_path)
                return df.to_string()
            
            else:
                raise ValueError(f"Unsupported file type: {file_ext}")
        
        except Exception as e:
            raise ValueError(f"Error extracting text: {str(e)}")
    
    def generate_embeddings(self, text: str) -> List[float]:
        """
        Generate embeddings for a given text
        """
        return self.embedding_model.encode(text).tolist()
    
    def _split_text(self, text: str, chunk_size: int = 500, overlap: int = 100) -> List[str]:
        """
        Split text into overlapping chunks
        """
        chunks = []
        words = text.split()
        for i in range(0, len(words), chunk_size - overlap):
            chunk = ' '.join(words[i:i+chunk_size])
            chunks.append(chunk)
        return chunks
    
    def index_document(self, file_id: str, text: str):
        """
        Index document text in ChromaDB
        """
        # Split text into chunks
        chunks = self._split_text(text)
        
        # Generate embeddings and store in ChromaDB
        embeddings = self.embedding_model.encode(chunks)
        
        # Upsert chunks into ChromaDB collection
        self.collection.upsert(
            ids=[f"{file_id}_chunk_{i}" for i in range(len(chunks))],
            embeddings=embeddings.tolist(),
            documents=chunks,
            metadatas=[{"file_id": file_id} for _ in chunks]
        )
        
        # Store file context
        self.file_contexts[file_id] = {
            'text': text,
            'chunks': chunks
        }
    
    def retrieve_relevant_context(self, query: str, top_k: int = 3):
        """
        Retrieve relevant context from indexed documents
        """
        # Generate query embedding
        query_embedding = self.generate_embeddings(query)
        
        # Perform similarity search in ChromaDB
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=top_k
        )
        
        # Extract and return relevant context
        return results['documents'][0] if results['documents'] else []
    
    def generate_response(self, query: str, file_id: str = None) -> str:
        """
        Generate response using Groq, incorporating context
        """
        # Retrieve relevant context from file
        context_snippets = []
        
        # If file_id is provided, use file context
        if file_id and file_id in self.file_contexts:
            context_snippets = self.retrieve_relevant_context(query)
        
        # Construct context-aware prompt
        context_prompt = "Relevant Context:\n" + "\n".join(context_snippets) + "\n\n"
        full_prompt = (
             context_prompt
        + "User Query: "
        + query
        + "\n\nRespond only within the scope of Indian law. Use appropriate sections, acts, or judgments where applicable.\n\nResponse:"
        )
        
        # Generate response using Groq
        try:
            chat_completion = self.groq_client.chat.completions.create(
                messages=[
                    {"role": "system", "content": 
                     "You are a specialized AI assistant for Indian law and police operations. "
                        "You only answer questions about Indian legal sections, acts, landmark judgments, "
                        "and provide procedural or crime analysis advice."
                     },
                    {"role": "user", "content": full_prompt}
                ],
                model=self.llm_model
            )
            
            response = chat_completion.choices[0].message.content
        except Exception as e:
            response = f"Error generating response: {str(e)}"
        
        return response

# Flask Application
app = Flask(__name__)

# Configure upload folder
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'pdf', 'docx', 'txt', 'csv', 'xlsx'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Initialize RAG System (replace with your actual API key)
rag_system = ContextAwareRAGSystem(
    groq_api_key='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'
)

def allowed_file(filename):
    """
    Check if file extension is allowed
    """
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['POST'])
def upload_file():
    """
    File upload endpoint
    """
    # Check if file is present
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    
    # Check if filename is empty
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    
    # File type validation
    if file and allowed_file(file.filename):
        # Generate unique filename
        filename = secure_filename(file.filename)
        file_id = str(uuid.uuid4())
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], f"{file_id}_{filename}")
        
        # Save file
        file.save(file_path)
        
        try:
            # Extract text and index document
            file_text = rag_system.extract_text_from_file(file_path)
            rag_system.index_document(file_id, file_text)
            
            return jsonify({
                'message': 'File uploaded and indexed successfully', 
                'file_id': file_id
            }), 200
        
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    return jsonify({'error': 'File type not allowed'}), 400

@app.route('/query', methods=['POST'])
def query_document():
    """
    Query endpoint for RAG-based document querying
    """
    # Get request data
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    query = data.get('query')
    file_id = data.get('file_id')
    
    if not query:
        return jsonify({'error': 'No query provided'}), 400
    
    if not file_id or file_id not in rag_system.file_contexts:
        return jsonify({'error': 'Invalid or missing file_id'}), 400
    
    try:
        # Generate response
        response = rag_system.generate_response(query, file_id)
        
        return jsonify({
            'query': query,
            'response': response
        }), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/clear', methods=['POST'])
def clear_context():
    """
    Clear all indexed documents and context
    """
    try:
        # Retrieve all document IDs
        all_docs = rag_system.collection.get()
        
        # Check if there are any documents to delete
        if all_docs['ids']:
            # Delete all documents by their IDs
            rag_system.collection.delete(ids=all_docs['ids'])
        
        # Clear file contexts
        rag_system.file_contexts.clear()
        
        return jsonify({'message': 'All contexts cleared successfully'}), 200
    
    except Exception as e:
        return jsonify({
            'error': f'Error clearing context: {str(e)}',
            'details': str(all_docs) if 'all_docs' in locals() else 'No additional details'
        }), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)