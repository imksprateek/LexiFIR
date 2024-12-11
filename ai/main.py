
import os

import geocoder
from flask import Flask, request, jsonify
from datetime import datetime
from bson import ObjectId
from crewai import Agent, Task, Crew, LLM
from crewai_tools import SerperDevTool
from langchain_core.tools import Tool
from typing import Dict, Any

app = Flask(__name__)

SERPER_API_KEY ='de889e85f13d1323a6a7a88f5718b1d60dd71af4'
GROQ_API_KEY ='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'

import getpass
import os

if "GROQ_API_KEY" not in os.environ:
    os.environ["GROQ_API_KEY"]='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'

from langchain_groq import ChatGroq

llm = ChatGroq(
    model="mixtral-8x7b-32768",
    temperature=0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
    # other params...
)

search_tool = SerperDevTool()

# Geocoding Tool
import requests

def get_coordinates(location: str) -> Dict[str, float]:
    try:
        # Prepare headers with a descriptive User-Agent
        headers = {
            'User-Agent': 'CrimeReportingApp/1.0 (https://yourapp.com; contact@yourapp.com)'
        }

        # Use requests instead of geocoder for more control
        params = {
            'q': location,
            'format': 'jsonv2',
            'limit': 1
        }

        response = requests.get(
            'https://nominatim.openstreetmap.org/search', 
            params=params, 
            headers=headers
        )

        # Check if request was successful
        if response.status_code == 200:
            data = response.json()
            if data and 'lat' in data[0] and 'lon' in data[0]:
                return {
                    "latitude": float(data[0]['lat']),
                    "longitude": float(data[0]['lon'])
                }
        
        # Fallback if no coordinates found
        return {"latitude": 0, "longitude": 0}

    except Exception as e:
        print(f"Geocoding error: {e}")
        return {"latitude": 0, "longitude": 0}

llm = LLM(
    model="groq/llama3-8b-8192",
    api_key=GROQ_API_KEY
)

import json
from groq import Groq  # Corrected import for Groq


def convert_string_to_json(input_string):
    """
    Converts a legal analysis string into a structured JSON format with specified fields.

    Args:
        input_string (str): The input string to convert into JSON.

    Returns:
        str: A JSON-formatted string parsed from the input string.
    """
    # Initialize the Groq client
    client = Groq()  # You'll need to set up API key via environment variable or direct initialization

    prompt = (
        "Convert the following text into a well-structured JSON format with the specified structure. "
        "Ensure all key sections, subsections, and their content are preserved. Use this format strictly: \n\n"
        "{\n"
        "  \"relatedSections\": [\n"
        "    {\n"
        "      \"sectionCode\": \"string\",\n"
        "      \"description\": \"string\",\n"
        "      \"relevanceScore\": 0,\n"
        "      \"reasoning\": \"string\"\n"
        "    }\n"
        "  ],\n"
        "  \"landmarkJudgments\": [\n"
        "    {\n"
        "      \"title\": \"string\",\n"
        "      \"summary\": \"string\",\n"
        "      \"url\": \"string\"\n"
        "    }\n"
        "  ]\n"
        "}\n\n"
        "Convert the text below into the above JSON format:\n\n"
        f"{input_string}\n\n"
        "Return ONLY the JSON string without any additional commentary or formatting."
    )

    try:
        # Use the chat.completions.create method 
        response = client.chat.completions.create(
            model="llama3-70b-8192",  # Choose an appropriate model
            messages=[
                {"role": "user", "content": prompt}
            ]
        )

        # Extract the text response from the completion
        json_text = response.choices[0].message.content.strip()

        # Validate the JSON string
        import json
        parsed_json = json.loads(json_text)

        return json.dumps(parsed_json, indent=2)  # Pretty-print JSON

    except json.JSONDecodeError:
        raise ValueError("The LLM did not return a valid JSON string.")
    except Exception as e:
        raise ValueError(f"An error occurred: {str(e)}")


    
def generate_comprehensive_legal_description(case_details: Dict[str, Any]):
       return (f"An incident of {case_details.get('what', 'undefined crime')} occurred "
           f"at {case_details.get('where', 'unknown location')} "
           f"on {case_details.get('when', 'unspecified date')}. "
           f"The incident involves {case_details.get('who', 'unidentified individuals')} "
           f"and was carried out through {case_details.get('how', 'unspecified method')}. "
           f"The potential motive appears to be {case_details.get('why', 'unclear')}. "
           f"Witness information: {case_details.get('witness', 'no witnesses reported')}. "
           f"A {case_details.get('weapon', 'weapon')} was reportedly used during the incident.")

def generate_comprehensive_legal_analysis(case_details: Dict[str, Any]):

    situation = (
        f"Analyze a murder case with the following details:\n"
        f"Crime: {case_details.get('what', '')} \n"
        f"Location: {case_details.get('where', '')} \n"
        f"Date: {case_details.get('when', '')} \n"
        f"Reason: {case_details.get('why', '')} \n"
        f"Witnesses: {case_details.get('witness', '')} \n"
        f"Weapon: {case_details.get('weapon', '')}"
    )
    # Legal Research and Analysis Agent
    planner = Agent(
        llm=llm,
        role="Legal Content planner",
        goal="Generate an in-depth legal analysis with relevant sections, landmark judgments, and detailed reasoning for the situation:{situation}",
        backstory=(
            "You are an expert legal researcher with extensive knowledge of Indian Penal Code, "
            "Criminal Procedure Code, and landmark judicial precedents. Your task is to provide "
            "a comprehensive and structured legal analysis of the given crime scenario."
        ),
        allow_delegation=False,
        verbose=True
    )
    
    plan=Task(

    
    # Legal Analysis Task
    description=(
        "1. Analyze the given situation :{situation} to identify the most relevant legal sections.\n"
        "2. Use the Serper tool to retrieve legal sections and landmark judgments associated with the situation.\n"
        "3. Provide a detailed reasoning for the relevance of each section.\n"
        "4. Include summaries and URLs for landmark judgments."
    ),
    # Providing a string template with placeholders
    # expected_output='{{"relatedSections": [{{"sectionCode": "IPC 22", "description": "Crime", "relevanceScore": 99.8, "reasoning": "Best match"}}], "landmarkJudgments": [{{"title": "Law case", "summary": "No judgment", "url": "https://ex.com"}}]}}',Z
            expected_output="""
LEGAL SECTIONS OF PRIMARY CONCERN:
1. IPC Section [Section Code]: 
   - Description: [Brief description of the legal section]
   - Relevance Score: [Percentage indicating importance]
   - Reasoning: [Very Detailed explanation of why this section applies]

2. [Additional Relevant Sections...]

LANDMARK JUDICIAL PRECEDENTS:
1. Case Name: [Full Case Title]
   - Key Insights: [Detailed Summary of the judgment's main points]
   - Official Reference: [URL]
   - Relevance to Current Case: [Direct or indirect connection explaination]

2. [Additional Landmark Judgments...]

LEGAL ANALYSIS SUMMARY:
[Comprehensive overview of legal implications]
""",
    agent=planner,
    output_format=json
    )


    # Prepare situation description
    situation = (
        f"Analyze a murder case with the following details:\n"
        f"Crime: {case_details.get('what', '')} \n"
        f"Location: {case_details.get('where', '')} \n"
        f"Date: {case_details.get('when', '')} \n"
        f"Reason: {case_details.get('why', '')} \n"
        f"Witnesses: {case_details.get('witness', '')} \n"
        f"Weapon: {case_details.get('weapon', '')}"
    )

    # Execute the task with error handling and fallback
    
        # Attempt to execute the task
    crew=Crew(
            agents=[planner],
            tasks=[plan]
            
        )
    legal_analysis =  crew.kickoff(inputs={"situation": situation})
    task_output = plan.output.raw
    
    print(task_output)
    # legal_json=legal_analysis.json_dict
    # print(legal_json)

    
    # legal_json=json.dumps(legal_analysis.json_dict, indent=2)
    # print(f"Raw Output: {legal_analysis.raw}")
    # if legal_analysis.json_dict:
    #    print(f"JSON Output: {json.dumps(legal_analysis.json_dict, indent=2)}")
    # if legal_analysis.pydantic:
    #   print(f"Pydantic Output: {legal_analysis.pydantic}")
    return task_output
        
        # If the result is a string, try to parse it

def format_legal_analysis(legal_analysis):
    """
    Format the legal analysis in a narrative, easy-to-read style
    """
    try:
        # Parse the legal analysis, removing any extra escaping
        if isinstance(legal_analysis, str):
            # Remove unnecessary escaping and parse
            legal_analysis = legal_analysis.replace('\\"', '"').replace('\\n', '\n')
            legal_analysis = json.loads(legal_analysis)
        
        # Narrative Introduction
        formatted_analysis = "Legal Analysis Report\n"
        formatted_analysis += "====================\n\n"

        # Related Legal Sections Analysis
        formatted_analysis += "Legal Sections of Primary Concern:\n"
        for section in legal_analysis.get('relatedSections', []):
            formatted_analysis += (
                f"• {section.get('sectionCode', 'Unspecified Section')} - "
                f"{section.get('description', 'No detailed description available')}\n"
                f"  Investigative Significance: {section.get('relevanceScore', 'N/A')}%\n"
                f"  Rationale: {section.get('reasoning', 'No specific reasoning provided')}\n\n"
            )

        # Landmark Judgments Interpretation
        formatted_analysis += "Relevant Judicial Precedents:\n"
        for index, judgment in enumerate(legal_analysis.get('landmarkJudgments', []), 1):
            formatted_analysis += (
                f"Case {index}: {judgment.get('title', 'Unnamed Case')}\n"
                f"  Key Insights: {judgment.get('summary', 'No summary available')}\n"
                f"  Official Record: {judgment.get('url', 'No reference link')}\n\n"
            )

        # Contextual Summary
        formatted_analysis += "Legal Interpretation Summary:\n"
        formatted_analysis += "- The above sections and judgments provide a comprehensive legal framework "
        formatted_analysis += "for understanding the potential legal implications of the incident.\n"
        formatted_analysis += "- Investigators should carefully consider these legal references "
        formatted_analysis += "while proceeding with the case.\n"

        return formatted_analysis
    
    except Exception as e:
        print(f"Error formatting legal analysis: {e}")
        return "Unable to generate a readable legal analysis report."

@app.route('/generate-case-report', methods=['POST'])
def create_case_report():
    # Validate input
    data = request.json
    required_fields = ['what', 'where', 'when', 'why', 'who', 'how', 'witness', 'weapon']
    
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Get coordinates
    location_coords = get_coordinates(data.get('where', ''))

    # Generate comprehensive legal analysis
    legal_analysis = generate_comprehensive_legal_analysis(data)
    legal_json=convert_string_to_json(legal_analysis)
    print(legal_json)
    legal_description=generate_comprehensive_legal_description(data)
    
    # Format the legal analysis for readability
    # formatted_legal_analysis = format_legal_analysis(legal_analysis)
    # print(formatted_legal_analysis)

    # Construct case report in the specified format
    case_report = {
        "_id": {"$oid": str(ObjectId())},
        "officerId": {
            "$ref": "users",
            "$id": {"$oid": str(ObjectId())}
        },
        "caseTitle": f"Case: {data.get('what', 'Undefined Incident')}",
        "incidentDescription": legal_description,
        "incidentDate": {
            "$date": datetime.now().isoformat() + "Z"
        },
        "location": {
            "latitude": location_coords.get('latitude', 0),
            "longitude": location_coords.get('longitude', 0),
            "address": data.get('where', 'Unknown Location')
        },
        "relatedSections & Landmark judgemnts": legal_json,
        "status": "under_investigation",
        "createdAt": {
            "$date": datetime.now().isoformat() + "Z"
        },
        "updatedAt": {
            "$date": datetime.now().isoformat() + "Z"
        },
        "_class": "studio.ksprateek.service.entity.FIR"
    }

    print(case_report['relatedSections & Landmark judgemnts'])

    return jsonify(case_report), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)