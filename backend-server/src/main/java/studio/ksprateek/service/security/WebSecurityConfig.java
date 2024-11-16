package studio.ksprateek.service.security;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import studio.ksprateek.service.util.jwtutils.JwtAuthenticationEntryPoint;
import studio.ksprateek.service.util.jwtutils.JwtFilter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    @Autowired
    private JwtAuthenticationEntryPoint authenticationEntryPoint;
    @Autowired
    private JwtFilter filter;

    @Bean
    protected PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(request -> request.requestMatchers("/swagger-ui/**","/swagger-resources/*",
                                "/v3/api-docs/**", "/login").permitAll()
                        .anyRequest().authenticated())
                // Send a 401 error response if user is not authentic.
                .exceptionHandling(exception -> exception.authenticationEntryPoint(authenticationEntryPoint))
                // no session management
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // filter the request and add authentication token
                .addFilterBefore(filter,  UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    AuthenticationManager customAuthenticationManager() {
        return authentication -> new UsernamePasswordAuthenticationToken("randomuser123","password");
    }

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI().addSecurityItem(new SecurityRequirement().
                        addList("Bearer Authentication"))
                .components(new Components().addSecuritySchemes
                        ("Bearer Authentication", createAPIKeyScheme()))
                .info(new Info().title("LexiFIR - Ensuring Legal Accuracy in Every Complaint")
                        .description("LexiFIR is an AI-driven mobile and web application developed to assist police officers in drafting accurate First Information Reports (FIRs) by providing legal recommendations in real time. It addresses the lack of immediate legal expertise in police stations by offering legally compliant, context-based guidance on relevant case laws, legal sections, and landmark judgments.")
                        .version("3.0").contact(new Contact().name("K S Prateek")
                                .email( "ksprateek2004@gmail.com").url("https://ksprateek.studio"))
                        .license(new License().name("MIT License")
                                .url("LICENSE.md")));
    }

    private SecurityScheme createAPIKeyScheme() {
        return new SecurityScheme().type(SecurityScheme.Type.HTTP)
                .bearerFormat("JWT")
                .scheme("bearer");
    }
}