import os
from typing import List, Dict, Union
from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage

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
        
        # Summary generation system message
        self.summary_system_message = SystemMessage(content="""
You are an expert summarizer. Generate a concise, key points summary of the given text. 
The summary should:
- Be no more than 3-4 sentences long
- Capture the most critical information
- Highlight the main actionable insights
- Use clear and direct language
- Focus on the core message and key recommendations
- Do not include any introductory phrases like "Here is a summary" or "In summary"
        """)
    
    def add_message(self, role: str, content: str):
        """
        Add a message to the conversation history
        """
        if role == "human":
            self.conversation_history.append(HumanMessage(content=content))
        elif role == "ai":
            self.conversation_history.append(AIMessage(content=content))
    
    def generate_summary(self, full_response: str) -> str:
        """
        Generate a summary of the full response
        """
        summary_messages = [
            self.summary_system_message,
            HumanMessage(content=f"Please generate a summary of the following text:\n\n{full_response}")
        ]
        
        summary_response = self.chat_model.invoke(summary_messages)
        return summary_response.content
    
    def get_response(self, user_message: str) -> Dict[str, str]:
        """
        Generate a response and summary based on conversation history
        """
        # Prepare messages for model input
        messages = [self.system_message] + self.conversation_history + [
            HumanMessage(content=user_message)
        ]
        
        # Get AI response
        response = self.chat_model.invoke(messages)
        full_response = response.content
        
        # Generate summary
        summary = self.generate_summary(full_response)
        
        # Add messages to conversation history
        self.add_message("human", user_message)
        self.add_message("ai", full_response)
        
        # Limit conversation history to prevent context overflow
        if len(self.conversation_history) > 10:
            self.conversation_history = self.conversation_history[-10:]
        
        return {
            "response": full_response,
            "summary": summary
        }
    
    def clear_conversation_history(self):
        """
        Clear the entire conversation history
        """
        self.conversation_history = []