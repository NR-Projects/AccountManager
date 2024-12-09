package com.ts.account_management_server.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {
    @Value("${application.security.jwt.secret-key}")
    private String secretKey;
    @Value("${application.security.jwt.expiration}")
    private long tokenExpiration;

    public String extractSubject(String token) {
        return extractClaim(token, Claims::getSubject);
    }
    public String generateToken(String userId) {
        return Jwts
                .builder()
                .claims(new HashMap<>())
                .subject(userId)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + tokenExpiration))
                .signWith(getSignInKey())
                .compact();
    }
    public boolean isTokenValid(String token) {
        try {
            return extractClaim(token, Claims::getExpiration).after(new Date());
        } catch (Exception ex) {
            return false;
        }
    }
    private <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = Jwts
                .parser()
                .verifyWith(getSignInKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
        return claimsResolver.apply(claims);
    }
    private SecretKey getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}