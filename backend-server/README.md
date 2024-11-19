# Backend Server Docs

## Test the API endpoints here: <a href="http://localhost:8080/swagger-ui/index.html#">Test</a>

### **Frontend-Backend API Request Sequence for Authentication**

This document outlines the sequence of API requests for the authentication flow. The details about the request structure, payloads, and responses can be referred to in the SwaggerUI API documentation.

---

## **Sequence of API Requests**

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
- **Next Step:** On successful registration, proceed to login.

---

### **4. Login**

- **Endpoint:** `/auth/login`
- **Action:** Authenticates the user and provides a JWT token for session management.
- **Next Step:** Use the token for authenticated API requests.

---

## **Sequence Summary**

1. **Send OTP** → 2. **Validate OTP** → 3. **Signup** → 4. **Login**

### **Notes for Frontend Developers**
- Ensure all requests are sequential and depend on the success of the previous step.
- Handle errors at each step with appropriate user feedback.
- Store the JWT token securely after login for authenticated requests.

Refer to SwaggerUI for detailed request and response structures.