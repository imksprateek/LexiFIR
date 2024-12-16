# LexiFIR

**LexiFIR** is a mobile application designed to assist the Madhya Pradesh Police by addressing the lack of legal expertise and improving operational efficiency. It leverages advanced AI-driven technologies to simplify investigations, enhance law enforcement, and provide critical tools for police personnel.

## Features

### 1. Conversational Chatbot
- Provides quick and accurate legal advice.
- Guides personnel through procedural tasks and legal documentation.

### 2. Investigation Assistance
- Aids in collecting the right evidence from crime scenes.
- Offers guidelines and checklists to ensure comprehensive evidence collection.

### 3. Landmark Judgments and References
- Provides access to significant court judgments and legal references.
- Enhances decision-making with accurate legal precedents.

### 4. Crime Pattern Analysis
- Analyzes nationwide crime trends and patterns using AI.
- Helps in strategizing better law enforcement practices.

### 5. Training Module
- Educates police personnel on legal procedures, evidence handling, and investigation techniques.
- Offers interactive content to improve knowledge retention and practical application.

## Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile application development.

### Backend and Microservices
- **AI Services**: PyTorch, LangChain, Flask.
- **Speech-to-Text Microservice**: Flask with WebSockets.

### Database
- **MongoDB Engine**: Hosted on **AWS DocumentDB** for secure and scalable data storage.

### Analytics
- **Power BI**: For generating actionable insights and visualizations.

### Cloud and Infrastructure
- **AWS**: Used for hosting backend services, database, and ensuring secure operations.

## Architecture Overview

LexiFIR integrates multiple layers to provide a seamless user experience:
1. **User Interface**: A Flutter-based mobile app for intuitive interaction.
2. **AI Services**: Powered by Flask and PyTorch for intelligent chatbot responses.
3. **Database**: CRUD operations managed through Spring Boot, with MongoDB in AWS DocumentDB.
4. **Microservices**: Real-time processing via Flask WebSockets for speech-to-text.
5. **Analytics**: Power BI integration for dashboards and reporting.

## Setup and Deployment

### Prerequisites
- Flutter SDK
- Python (for Flask and PyTorch services)
- MongoDB (AWS DocumentDB credentials)
- Power BI (for analytics)
- AWS CLI for managing cloud resources

### Steps to Set Up
1. **Frontend**:
   - Install Flutter SDK and set up your environment.
   - Clone the repository and run `flutter pub get` to install dependencies.
   - Launch the app with `flutter run`.

2. **Backend Services**:
   - Set up Flask for AI services and microservices.
   - Deploy the trained PyTorch model in the AI service.
   - Use AWS DocumentDB for the MongoDB database connection.

3. **Database**:
   - Configure Spring Boot to connect with MongoDB in AWS DocumentDB.
   - Ensure proper database indices for faster querying.

4. **Analytics**:
   - Connect Power BI to AWS DocumentDB for data visualization.
   - Create dashboards and publish them for integration with the app.

5. **Deployment**:
   - Host the backend services on AWS.
   - Use a CI/CD pipeline to streamline app updates and deployments.

## Usage
- **Login**: Police personnel can log in securely through the app.
- **Chatbot**: Use the conversational interface for legal advice and assistance.
- **Training**: Access the training module to improve skills and knowledge.
- **Analytics**: View crime trends and insights through the integrated dashboards.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

### Support  
For any queries, issues, or suggestions, please feel free to open an issue in this repository or contact the development team.  

### Future Enhancements  
We are continuously working to improve LexiFIR. Planned features include:  
- Integration with real-time crime alert systems.  
- Advanced natural language processing for more nuanced chatbot responses.  
- Role-based access control for enhanced security.  
- Multi-language support for improved accessibility (The app supports only Hindi and English).  

### Acknowledgments  
We would like to thank the Madhya Pradesh Police Department for their valuable insights and feedback during the development of this application. Their real-world challenges inspired us to create LexiFIR.  
### Smart India Hackathon 2024
LexiFIR was developed in **36 hours** at the **Smart India Hackathon 2024 Grand Finale** in Bhopal, Madhya Pradesh. We are proud of the effort and collaboration that went into creating this app in such a short span of time.  

**Team Members**:
- [K S Prateek](https://github.com/imksprateek/)
- [Nirupam Naragund](https://github.com/Nirupam-Naragund)
- [Kedar Bhagat](https://github.com/Kedarbhagat)
- [Venkatnarayanan B](https://github.com/Bvn004)
- [Mokshita Chourasia](https://github.com/Mokshita-Chourasia)
- [Mohith H M](https://github.com/mohithhm)


---

**Let’s empower law enforcement with innovation and precision!**  
Explore the repository, contribute, and help us make a difference with LexiFIR. 🚀  

[Check out our Wiki for more details on features](https://github.com/imksprateek/finale-dev-env/wiki)


