package com.ts.account_management_server.model;

import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.handler.impl.LinkedAccountHandler;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.repository.AccountRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ActiveProfiles("dev")
@SpringBootTest
public class ReferenceLinkedAccountTests {

    @Mock
    private AccountRepository accountRepository;

    @InjectMocks
    @Autowired
    private LinkedAccountHandler linkedAccountHandler;

    private LinkedAccount linkedAccount1;
    private LinkedAccount linkedAccount2;
    private LinkedAccount linkedAccount3;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        // Initialize LinkedAccount instances
        linkedAccount1 = new LinkedAccount();
        linkedAccount1.setId("id1");

        linkedAccount2 = new LinkedAccount();
        linkedAccount2.setId("id2");

        linkedAccount3 = new LinkedAccount();
        linkedAccount3.setId("id3");
    }

    @Test
    void testSelfReferenceThrowsException() {
        // Simulate self-reference
        linkedAccount1.setLinkedAccount(linkedAccount1);

        LinkException exception = assertThrows(LinkException.class, () -> {
            linkedAccountHandler.updateAccount(linkedAccount1);
        });

        assertEquals("Linked account cannot reference itself", exception.getMessage());
        verify(accountRepository, never()).save(any());
    }

    @Test
    void testCircularReferenceThrowsException() {
        // Create a circular reference: linkedAccount1 -> linkedAccount2 -> linkedAccount1
        linkedAccount1.setLinkedAccount(linkedAccount2);
        linkedAccount2.setLinkedAccount(linkedAccount1);

        LinkException exception = assertThrows(LinkException.class, () -> {
            linkedAccountHandler.updateAccount(linkedAccount1);
        });

        assertEquals("Circular reference detected in linked accounts", exception.getMessage());
        verify(accountRepository, never()).save(any());
    }

    @Test
    void testDeepCircularReferenceThrowsException() {
        // Create a circular reference: linkedAccount1 -> linkedAccount2 -> linkedAccount3 -> linkedAccount1
        linkedAccount1.setLinkedAccount(linkedAccount2);
        linkedAccount2.setLinkedAccount(linkedAccount3);
        linkedAccount3.setLinkedAccount(linkedAccount1);

        LinkException exception = assertThrows(LinkException.class, () -> {
            linkedAccountHandler.updateAccount(linkedAccount1);
        });

        assertEquals("Circular reference detected in linked accounts", exception.getMessage());
        verify(accountRepository, never()).save(any());

    }

    @Test
    void testValidLinkedAccountSavesSuccessfully() {
        // Create a valid linked account chain
        linkedAccount1.setLinkedAccount(linkedAccount2);
        linkedAccount2.setLinkedAccount(null);

        // Simulate repository save
        when(accountRepository.save(linkedAccount1)).thenReturn(linkedAccount1);

        assertDoesNotThrow(() -> {
            linkedAccountHandler.updateAccount(linkedAccount1);
        });

        verify(accountRepository, times(1)).save(linkedAccount1);
    }
}
