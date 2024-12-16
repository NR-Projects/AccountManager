package com.ts.account_management_server.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

@Service
public class EncryptionService {

    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128; // Auth tag length in bits
    private static final int IV_LENGTH = 12; // Recommended IV length for GCM (12 bytes)
    private static final int AES_KEY_SIZE = 256; // AES-256 key size in bits

    @Value("${application.security.encryption.secret}")
    private String secretKey;

    private SecretKey getSecretKey() {
        byte[] keyBytes = Base64.getDecoder().decode(secretKey);

        // Ensure the key is exactly 32 bytes
        if (keyBytes.length != 32) {
            throw new IllegalArgumentException("Secret key must be 32 bytes for AES-256 encryption");
        }
        return new SecretKeySpec(keyBytes, ALGORITHM);
    }


    // Generate a secure random IV
    private byte[] generateIV() {
        byte[] iv = new byte[IV_LENGTH];
        new SecureRandom().nextBytes(iv);
        return iv;
    }

    // Encrypt method
    public String encrypt(String plainText) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        // Generate IV for this encryption operation
        byte[] iv = generateIV();

        // Initialize the cipher with the secret key and IV
        SecretKey key = getSecretKey();
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec);

        // Encrypt the data
        byte[] cipherText = cipher.doFinal(plainText.getBytes());

        // Combine IV + CipherText and encode it as Base64
        byte[] combined = new byte[IV_LENGTH + cipherText.length];
        System.arraycopy(iv, 0, combined, 0, IV_LENGTH);
        System.arraycopy(cipherText, 0, combined, IV_LENGTH, cipherText.length);

        return Base64.getEncoder().encodeToString(combined);
    }

    // Decrypt method
    public String decrypt(String encryptedText) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        // Decode the encrypted text
        byte[] decodedBytes = Base64.getDecoder().decode(encryptedText);

        // Extract IV from the combined IV + CipherText
        byte[] iv = new byte[IV_LENGTH];
        byte[] cipherText = new byte[decodedBytes.length - IV_LENGTH];
        System.arraycopy(decodedBytes, 0, iv, 0, IV_LENGTH);
        System.arraycopy(decodedBytes, IV_LENGTH, cipherText, 0, cipherText.length);

        // Initialize the cipher with the secret key and IV
        SecretKey key = getSecretKey();
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, gcmSpec);

        // Decrypt the data
        byte[] decryptedText = cipher.doFinal(cipherText);
        return new String(decryptedText);
    }

    // Helper method to generate a strong 256-bit AES key (for setup purposes)
    public static String generateRandomSecretKey() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance(ALGORITHM);
        keyGen.init(AES_KEY_SIZE);
        SecretKey key = keyGen.generateKey();
        return Base64.getEncoder().encodeToString(key.getEncoded());
    }
}
