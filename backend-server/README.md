# Backend Server Docs

## Test the API endpoints here: <a href="http://server.ksprateek.studio/swagger-ui/index.html#/">Test</a>

### **Frontend-Backend API Request Sequence for Authentication**

This document outlines the sequence of API requests for the authentication flow. The details about the request structure, payloads, and responses can be referred to in the SwaggerUI API documentation.

---

**BASE URL:** `http://server.ksprateek.studio`

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
- **Next Step:** On successful registration, proceed to the onboarding process.

---

### **4. Onboarding (Collect Name & Set Username)**

- **Action:** After signup, collect the user's full name and prompt them to set a unique username.
- **Next Step:** Send a request to check if the username is unique.

---

### **5. Check Username Availability**

- **Endpoint:** `/auth/checkuser`
- **Action:** Checks if the entered username is unique. Proceed if the username is available.

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

### **Notes for Frontend Developers**
- Ensure all requests are sequential and depend on the success of the previous step.
- Handle errors at each step with appropriate user feedback (e.g., invalid OTP, username already taken).
- After login, make a PUT request to `/api/users/{id}` to update the user’s full name and username (partial updates allowed).
- Store the JWT token securely after login for authenticated requests. Add the token as a bearer token in the `Authorization` header for subsequent API calls.

Refer to SwaggerUI for detailed request and response structures.
