Here's the updated **Backend Server Docs** with the mention that the AI Legal Chatbot is context-aware:

---

# Backend Server Docs

## Test the API endpoints here: <a href="http://server.ksprateek.studio/swagger-ui/index.html#/">Test</a>

### **Frontend-Backend API Request Sequence for Authentication**

This document outlines the sequence of API requests for the authentication flow. The details about the request structure, payloads, and responses can be referred to in the SwaggerUI API documentation.

---

**BASE URL:** `http://server.ksprateek.studio`

---

## **Auth**

### **1. Send OTP**

- **Endpoint:** `/auth/sendotp`
- **Action:** Sends a 4-digit OTP to the user's email for verification.
- **Next Step:** Proceed to validate OTP after receiving a success response.

---

### **2. Validate OTP**

- **Endpoint:** `/auth/validateotp`
- **Action:** Validates the OTP provided by the user.
- **Next Step:** If the OTP is valid, proceed to signup.

---

### **3. Signup**

- **Endpoint:** `/auth/signup`
- **Action:** Registers the user with their email, password, and name.
- **Next Step:** On successful registration, proceed to the onboarding process.

---

### **4. Onboarding (Collect Name & Set Username)**

- **Action:** After signup, collect the user's full name and prompt them to set a unique username.
- **Next Step:** Send a request to check if the username is unique.

---

### **5. Check Username Availability**

- **Endpoint:** `/auth/checkuser`
- **Action:** Checks if the entered username and email are both unique. Proceed if the username is available.

---

### **6. Login**

- **Endpoint:** `/auth/login`
- **Action:** Authenticates the user and provides a JWT token for session management.
- **Next Step:** Store the JWT token securely and use it in the headers as a bearer token in all subsequent requests. The response also includes the user's ID.

---

### **7. Update User Details (After Login)**

- **Endpoint:** `/api/users/{id}`
- **Method:** PUT
- **Action:** Update the user’s details (full name, username, etc.). Partial updates are supported.
- **Path Variable:** The user's ID is obtained from the login response and used in the request path.

---

## **Sequence Summary**

1. **Send OTP** → 2. **Validate OTP** → 3. **Signup** → 4. **Onboarding** (Collect Name & Set Username) → 5. **Check Username** → 6. **Login** → 7. **Update User Details**

---

## **Speech-to-Text Real-time Streaming**

### **English Speech-to-Text Service**
- Speech-to-text real-time streaming is deployed and working as expected (English). Check the example `client.py` file in the repo and establish a WebSocket connection using the following endpoint:
  - **WebSocket Endpoint:** `ws://eng.ksprateek.studio/TranscribeStreaming`

---

### **Hindi Speech-to-Text Service**
- Hindi speech-to-text service has been deployed. You can access it via the WebSocket connection at:
  - **WebSocket Endpoint:** `ws://hin.ksprateek.studio/TranscribeStreaming`

---

### **Flow of Speech-to-Text for Conversational AI in Hindi**
1. Receive the **Hindi response** from the WebSocket server.
2. Translate the Hindi text to **English** using the **Flutter Translate package**.
3. Send the translated English text to the **AI service**.
4. Retrieve the AI-generated response and proceed with further processing.

---

## **AI Legal Chatbot**

### **Chatbot Service Endpoint**
- The AI Legal Chatbot is deployed and can be accessed at the following Endpoint:
  - **Endpoint:** `http://chat.ksprateek.studio/chat`

### **Request Format**
- To interact with the AI Legal Chatbot, send a **POST** request with the following body format:

```json
{
  "message": "What does section 360 say"
}
```

- The chatbot will process the message and return a response based on the queried legal section or topic.

### **Context Awareness**
- The AI Legal Chatbot is **context-aware**, meaning it can remember the context of previous interactions within the current session. This allows for a more dynamic and relevant response based on prior queries, helping users with more coherent and connected legal assistance.

---

### **Notes for Frontend Developers**
- Ensure all requests are sequential and depend on the success of the previous step in the authentication flow.
- Handle errors with appropriate user feedback (e.g., invalid OTP, username already taken).
- Store the JWT token securely after login for authenticated requests and include it as a `Bearer` token in the `Authorization` header.
- Integrate the STT WebSocket services for English and Hindi as per your application's requirements.
- To interact with the AI Legal Chatbot, use the provided endpoint and request format. The context-awareness feature should be leveraged for more natural and ongoing conversations with the chatbot.
  
Refer to SwaggerUI for detailed request and response structures.
