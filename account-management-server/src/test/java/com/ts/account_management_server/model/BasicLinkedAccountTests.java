package com.ts.account_management_server.model;

import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.repository.AccountRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ActiveProfiles("dev")
@SpringBootTest
public class BasicLinkedAccountTests {

    @Mock
    private AccountRepository linkedAccountRepository; // Mocked Repository

    @Mock
    private MongoTemplate mongoTemplate; // Mocked MongoTemplate

    private LinkedAccount linkedAccount1;
    private LinkedAccount linkedAccount2;

    @BeforeEach
    void setUp() {
        // Initialize mocks
        MockitoAnnotations.openMocks(this);

        // Initialize LinkedAccount objects
        linkedAccount1 = new LinkedAccount();
        linkedAccount1.setId("id1");

        linkedAccount2 = new LinkedAccount();
        linkedAccount2.setId("id2");

        UsernamePasswordAccount usernamePasswordAccount = new UsernamePasswordAccount();
        usernamePasswordAccount.setLabel("label");
        usernamePasswordAccount.setUsername("user1");
        usernamePasswordAccount.setPassword("pass1");

        // Mock MongoTemplate behavior
        when(mongoTemplate.save(usernamePasswordAccount)).thenReturn(usernamePasswordAccount);
        when(mongoTemplate.save(linkedAccount2)).thenReturn(linkedAccount2);
        when(mongoTemplate.save(linkedAccount1)).thenReturn(linkedAccount1);

        // Mock LinkedAccountRepository save behavior
        when(linkedAccountRepository.save(linkedAccount1)).thenReturn(linkedAccount1);
        when(linkedAccountRepository.save(linkedAccount2)).thenReturn(linkedAccount2);
    }

    @Test
    void testLinkedAccountSave() {
        // Simulate saving linkedAccount1
        LinkedAccount savedAccount = linkedAccountRepository.save(linkedAccount1);

        assertNotNull(savedAccount.getId(), "Account should have an ID after saving");
        assertNull(savedAccount.getLinkedAccount(), "Linked account must be null initially");

        // Verify the save was called on repository
        verify(linkedAccountRepository, times(1)).save(linkedAccount1);
    }

    @Test
    void testLinkingAccounts() {
        // Link linkedAccount1 to linkedAccount2
        linkedAccount1.setLinkedAccount(linkedAccount2);

        // Simulate repository save
        when(linkedAccountRepository.save(linkedAccount1)).thenReturn(linkedAccount1);
        LinkedAccount savedAccount = linkedAccountRepository.save(linkedAccount1);

        // Assertions
        assertNotNull(savedAccount.getLinkedAccount(), "Linked account should not be null");
        assertEquals(linkedAccount2.getId(), savedAccount.getLinkedAccount().getId(), "Linked account ID should match");

        // Verify interaction
        verify(linkedAccountRepository, times(1)).save(linkedAccount1);
    }

    @Test
    void testRetrieveLinkedAccount() {
        // Link linkedAccount1 to linkedAccount2
        linkedAccount1.setLinkedAccount(linkedAccount2);

        // Mock repository findById behavior
        when(linkedAccountRepository.findById(linkedAccount1.getId())).thenReturn(Optional.of(linkedAccount1));

        // Retrieve account
        LinkedAccount retrievedAccount = (LinkedAccount) linkedAccountRepository.findById(linkedAccount1.getId()).orElse(null);

        // Assertions
        assertNotNull(retrievedAccount, "Account should be retrieved");
        assertNotNull(retrievedAccount.getLinkedAccount(), "Linked account should not be null");
        assertEquals(linkedAccount2.getId(), retrievedAccount.getLinkedAccount().getId(), "Linked account ID should match");

        // Verify repository interaction
        verify(linkedAccountRepository, times(1)).findById(linkedAccount1.getId());
    }

    @Test
    void testUnlinkAccount() {
        // Link linkedAccount1 to linkedAccount2
        linkedAccount1.setLinkedAccount(linkedAccount2);

        // Simulate repository save
        when(linkedAccountRepository.save(linkedAccount1)).thenReturn(linkedAccount1);
        linkedAccountRepository.save(linkedAccount1);

        // Unlink the account
        linkedAccount1.setLinkedAccount(null);
        when(linkedAccountRepository.save(linkedAccount1)).thenReturn(linkedAccount1);
        LinkedAccount updatedAccount = linkedAccountRepository.save(linkedAccount1);

        // Assertions
        assertNull(updatedAccount.getLinkedAccount(), "Linked account should be null after unlinking");

        // Verify interactions
        verify(linkedAccountRepository, times(2)).save(linkedAccount1);
    }
}
