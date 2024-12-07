package com.ts.account_management_server.config;

import com.ts.account_management_server.model.database.UserRole;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.ts.account_management_server.filter.JwtAuthFilter;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {
    
    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(
                        req -> req
                                // Public endpoints
                                .requestMatchers("/auth/login").permitAll()
                                .requestMatchers("/user/register-device").permitAll()

                                // Admin-only endpoints
                                .requestMatchers("/user/all").hasAuthority(UserRole.ADMIN.name())
                                .requestMatchers(HttpMethod.PUT, "/user").hasAuthority(UserRole.ADMIN.name())
                                .requestMatchers("/user/{userId}").hasAuthority(UserRole.ADMIN.name())

                                // Guest or Admin endpoints
                                .requestMatchers("/site/**").hasAnyAuthority(UserRole.GUEST.name(), UserRole.ADMIN.name())
                                .requestMatchers("/account/**").hasAnyAuthority(UserRole.GUEST.name(), UserRole.ADMIN.name())

                                // Server config endpoints (specific to Admin)
                                .requestMatchers("/server-config/disable-guest-requests").hasAnyAuthority(UserRole.GUEST.name(), UserRole.ADMIN.name())
                                .requestMatchers("/server-config/enable-guest-requests").hasAuthority(UserRole.ADMIN.name())
                                .requestMatchers("/server-config").hasAuthority(UserRole.ADMIN.name())
                                .requestMatchers("/server-config/change-master-password").hasAuthority(UserRole.ADMIN.name())
                                .requestMatchers("/server-config/clear-data").hasAuthority(UserRole.ADMIN.name())

                                .anyRequest().authenticated()
                )
                .sessionManagement(
                        session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }
}
