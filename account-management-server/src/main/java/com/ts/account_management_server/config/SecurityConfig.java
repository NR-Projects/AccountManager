package com.ts.account_management_server.config;

import com.ts.account_management_server.filter.JwtAuthFilter;
import com.ts.account_management_server.model.enums.UserDeviceRole;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

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
                                .requestMatchers("/auth/login")
                                    .permitAll()
                                .requestMatchers("/user/register-device")
                                    .permitAll()

                                // Admin-only endpoints
                                .requestMatchers("/user/all")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())
                                .requestMatchers("/user")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())
                                .requestMatchers("/user/{userId}")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())

                                // Guest or Admin endpoints
                                .requestMatchers("/site/**")
                                    .hasAnyAuthority(
                                        UserDeviceRole.GUEST.name(),
                                        UserDeviceRole.ADMIN.name()
                                )
                                .requestMatchers("/account/**")
                                    .hasAnyAuthority(
                                        UserDeviceRole.GUEST.name(),
                                        UserDeviceRole.ADMIN.name()
                                )

                                // Server config endpoints (specific to Admin)
                                .requestMatchers("/server-config/disable-guest-requests")
                                    .hasAnyAuthority(
                                        UserDeviceRole.GUEST.name(),
                                        UserDeviceRole.ADMIN.name()
                                )
                                .requestMatchers("/server-config/enable-guest-requests")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())
                                .requestMatchers("/server-config")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())
                                .requestMatchers("/server-config/change-master-password")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())
                                .requestMatchers("/server-config/clear-data")
                                    .hasAuthority(UserDeviceRole.ADMIN.name())

                                .anyRequest()
                                    .authenticated()
                )
                .sessionManagement(
                        session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
