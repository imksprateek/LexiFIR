import os
from typing import List, Dict
from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
# from dotenv import load_dotenv

# Load environment variables
# load_dotenv()

class ContextAwareChatbot:
    def __init__(self, model_name="llama3-70b-8192"):
        """
        Initialize the chatbot with Groq's Llama 3.1 70b model
        """
        self.chat_model = ChatGroq(
            groq_api_key='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',
            model_name=model_name
        )
        
        # Initialize conversation history
        self.conversation_history: List[Dict] = []
        
        # System prompt to define chatbot's behavior
        self.system_message = SystemMessage(content="""
You are an AI assistant specializing in Indian legal services, designed exclusively to assist police officers. 

Your primary role is to:
- Identify relevant IPC sections, landmark judgments, and legal precedents.
- Provide actionable guidance on gathering evidence based on crime descriptions.
- Suggest procedural steps for investigation and legal compliance.
- Support law enforcement with accurate, detailed, and ethically sound advice.

**Response Guidelines:**
- Always provide responses in a structured, clear, and concise format.
- Use bullet points, numbered lists, or appropriate headings to make the response easy to read.
- Include line breaks between sections for better clarity and presentation.

**Important:**
If a question is unrelated to Indian legal services or law enforcement assistance, respond strictly with:  
"This is not a related legal query."  

Do not provide additional information or engage with unrelated topics.
        """)
    
    def add_message(self, role: str, content: str):
        """
        Add a message to the conversation history
        """
        if role == "human":
            self.conversation_history.append(HumanMessage(content=content))
        elif role == "ai":
            self.conversation_history.append(AIMessage(content=content))
    
    def get_response(self, user_message: str) -> str:
        """
        Generate a response based on conversation history
        """
        # Prepare messages for model input
        messages = [self.system_message] + self.conversation_history + [
            HumanMessage(content=user_message)
        ]
        
        # Get AI response
        response = self.chat_model.invoke(messages)
        
        # Add messages to conversation history
        self.add_message("human", user_message)
        self.add_message("ai", response.content)
        
        # Limit conversation history to prevent context overflow
        if len(self.conversation_history) > 10:
            self.conversation_history = self.conversation_history[-10:]
        
        return response.content
    
    def clear_conversation_history(self):
        """
        Clear the entire conversation history
        """
        self.conversation_history = []