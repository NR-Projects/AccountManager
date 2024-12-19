package com.ts.account_management_server.model;

import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.service.AccountService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@ActiveProfiles("dev")
@SpringBootTest
public class ReferenceLinkedAccountTests {

    @Mock
    private AccountService accountService;

    private LinkedAccount linkedAccount1;
    private LinkedAccount linkedAccount2;
    private LinkedAccount linkedAccount3;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        // Create LinkedAccount instances
        linkedAccount1 = new LinkedAccount();
        linkedAccount1.setId("id1");

        linkedAccount2 = new LinkedAccount();
        linkedAccount2.setId("id2");

        linkedAccount3 = new LinkedAccount();
        linkedAccount3.setId("id3");
    }

    @Test
    void testSameLinkedAccountNotAllowed() {
        // Attempt to link an account to itself
        Exception exception = assertThrows(Exception.class, () -> {
            linkedAccount1.setLinkedAccount(linkedAccount1);
            accountService.updateAccount(linkedAccount1);
        });

        assertEquals("Linked account cannot reference itself", exception.getMessage());
    }

    @Test
    void testCircularReferenceNotAllowed() {
        // Create circular reference: linkedAccount1 -> linkedAccount2 -> linkedAccount1
        Exception exception = assertThrows(Exception.class, () -> {
            linkedAccount1.setLinkedAccount(linkedAccount2);
            linkedAccount2.setLinkedAccount(linkedAccount1);
            accountService.updateAccount(linkedAccount1);
        });

        assertEquals("Circular reference detected in linked accounts", exception.getMessage());
    }

    @Test
    void testDeepCircularReferenceNotAllowed() {
        // Create a deeper circular reference: linkedAccount1 -> linkedAccount2 -> linkedAccount3 -> linkedAccount1
        Exception exception = assertThrows(Exception.class, () -> {
            linkedAccount1.setLinkedAccount(linkedAccount2);
            linkedAccount2.setLinkedAccount(linkedAccount3);
            linkedAccount3.setLinkedAccount(linkedAccount1);
            accountService.updateAccount(linkedAccount1);
        });

        assertEquals("Circular reference detected in linked accounts", exception.getMessage());
    }
}
