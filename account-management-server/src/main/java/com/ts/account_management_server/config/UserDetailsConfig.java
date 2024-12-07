package com.ts.account_management_server.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.ts.account_management_server.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class UserDetailsConfig {

    private final UserRepository userRepository;

    @Bean
    public UserDetailsService loadUserByLabel() {
        return label -> userRepository.findByDeviceLabel(label)
            .orElseThrow(() -> new UsernameNotFoundException("User does not exist!"));
    }
}
