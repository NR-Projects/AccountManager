package com.ts.account_management_server.filter;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import com.ts.account_management_server.model.database.User;
import com.ts.account_management_server.service.JwtService;
import com.ts.account_management_server.service.UserService;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final UserService userService;
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

        // Get token and username
        String jwtTokenString = authorizationHeader.substring(7);

        // Check if valid
        if (!jwtService.isTokenValid(jwtTokenString)) {
            filterChain.doFilter(request, response);
            return;
        }

        String userId = jwtService.extractSubject(jwtTokenString);

        // Check if Jwt has subject and no auth yet
        if (userId == null || SecurityContextHolder.getContext().getAuthentication() != null) {
            filterChain.doFilter(request, response);
            return;
        }

        // Get User Object from id
        User user = userService.getUserById(userId);

        // Check if userDetails is null
        if (user == null) {
            filterChain.doFilter(request, response);
            return;
        }

        // Check if token is valid and allowed
        if (user.getCurrentToken().equals(jwtTokenString)) {

            // Create authentication token with authorities
            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                    user,
                    null,
                    user.getAuthorities()
            );
            SecurityContextHolder.getContext().setAuthentication(authToken);
        }

        filterChain.doFilter(request, response);
    }

}
