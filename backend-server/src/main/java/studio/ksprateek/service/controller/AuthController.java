package studio.ksprateek.service.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.mail.MessagingException;
import jakarta.validation.Valid;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import studio.ksprateek.service.payload.requests.*;
import studio.ksprateek.service.payload.responses.AuthResponse;
import studio.ksprateek.service.payload.responses.JwtResponse;
import studio.ksprateek.service.payload.responses.MessageResponse;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.repository.RoleRepository;
import studio.ksprateek.service.repository.UserRepository;
import studio.ksprateek.service.security.jwt.JwtUtils;
import studio.ksprateek.service.service.auth.OtpService;
import studio.ksprateek.service.service.user.UserDetailsImpl;
import studio.ksprateek.service.models.ERole;
import studio.ksprateek.service.models.Role;
import studio.ksprateek.service.service.user.UserDetailsServiceImpl;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
@Tag(name = "1. Authentication", description = "Operations related to user Authentication")
public class AuthController {
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    RoleRepository roleRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    OtpService otpService;
    @Autowired
    private UserDetailsServiceImpl userDetailsServiceImpl;

    @PostMapping("/login")
    @Operation(
            summary = "Log the user in",
            description = "Authenticates a user by verifying their username and password. Returns a JWT token if authentication is successful.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "Successfully logged in. Returns a JWT token.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = JwtResponse.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "Invalid credentials provided. Login failed."
                    )
            }
    )

    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                roles));
    }

    @PostMapping("/signup")
    @Operation(
            summary = "Register user in the database",
            description = "Registers a new user by saving their username, email, and encrypted password to the database. Also assigns roles (if any).",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "User registered successfully."
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "Username or Email already exists.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = MessageResponse.class)
                            )
                    )
            }
    )
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignUpRequest signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username is already taken!"));
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Email is already in use!"));
        }

        // Create new user's account
        User user = new User(signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()));

        Set<String> strRoles = signUpRequest.getRoles();
        Set<Role> roles = new HashSet<>();

        if (strRoles == null) {
            Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(adminRole);

                        break;
                    case "mod":
                        Role modRole = roleRepository.findByName(ERole.ROLE_MODERATOR)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(modRole);

                        break;
                    default:
                        Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(userRole);
                }
            });
        }

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }

    @PostMapping("sendotp")
    @Operation(
            summary = "Send otp to user's email",
            description = "Sends a one-time password (OTP) to the user's email for verification. The OTP will be used to validate the user's identity.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "OTP sent successfully to the email.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = AuthResponse.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "422",
                            description = "Failed to send OTP.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = AuthResponse.class)
                            )
                    )
            }
    )
    public ResponseEntity<AuthResponse> sendOtp(@RequestBody OtpRequest otpRequest) throws MessagingException {
        Logger logger = LoggerFactory.getLogger(AuthController.class);
        logger.info("Received OTP request for email: {}", otpRequest.getEmail());


        AuthResponse response = otpService.sendOtp(otpRequest);
        if (response.getStatusCode() == 200) {
            logger.info("OTP sent successfully to email: {}", otpRequest.getEmail());
            return ResponseEntity.ok(response);
        } else {
            logger.error("Failed to send OTP to email: {}", otpRequest.getEmail());
            return ResponseEntity.unprocessableEntity().body(response);
        }
    }

    @PostMapping("validateotp")
    @Operation(
            summary = "Verify if the OTP entered is valid",
            description = "Validates the OTP entered by the user to verify their identity.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "OTP is valid. Returns a response with the status of the verification.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = AuthResponse.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "OTP is invalid or expired.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = AuthResponse.class)
                            )
                    )
            }
    )
    public AuthResponse validateOtp(@RequestBody OtpValidation otpValidationRequest){
        return otpService.validateOtp(otpValidationRequest);
    }

    @PostMapping("checkuser")
    @Operation(
            summary = "Checks if the user's email is already registered in the DB",
            description = "Checks whether the provided username or email already exists in the database. Returns an appropriate message for login or signup.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "User can proceed to sign up."
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "User already exists or email already exists. Suggests login instead."
                    )
            }
    )
    public ResponseEntity<?> checkUser(@RequestBody UserCheck userCheck){
        if(userDetailsServiceImpl.userExists(userCheck.getUsername())){
            return ResponseEntity.badRequest().body("User already exists. Login instead");
        }else if(userDetailsServiceImpl.emailExists(userCheck.getEmail())){
            return ResponseEntity.badRequest().body("Email already exists. Login instead");
        }
        return ResponseEntity.ok().body("You can proceed to sign up");
    }

}
