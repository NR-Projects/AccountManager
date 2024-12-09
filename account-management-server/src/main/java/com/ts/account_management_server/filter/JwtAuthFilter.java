package com.ts.account_management_server.filter;

import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.service.JwtService;
import com.ts.account_management_server.service.UserDeviceService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final UserDeviceService userDeviceService;
    private final JwtService jwtService;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {

        String authorizationHeader = request.getHeader("Authorization");

        // Check if Authorization header exists and is valid
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // Get jwt token
        String jwtTokenString = authorizationHeader.substring(7);

        // Check if valid
        if (!jwtService.isTokenValid(jwtTokenString)) {
            filterChain.doFilter(request, response);
            return;
        }

        // Get the subject id (this is the userId/userDeviceId)
        String userDeviceId = jwtService.extractSubject(jwtTokenString);

        // Check if Jwt has subject and no auth yet
        if (userDeviceId == null || SecurityContextHolder.getContext().getAuthentication() != null) {
            filterChain.doFilter(request, response);
            return;
        }

        // Get UserDevice Object from id
        UserDevice userDevice = userDeviceService.getUserDeviceById(userDeviceId);

        // Check if userDetails is null
        if (userDevice == null) {
            filterChain.doFilter(request, response);
            return;
        }

        // Check if token is valid and allowed
        if (!jwtTokenString.equals(userDevice.getCurrentToken())) {
            filterChain.doFilter(request, response);
            return;
        }

        // Create authentication token with authorities
        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                userDevice,
                null,
                userDevice.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(authToken);
    }
}
