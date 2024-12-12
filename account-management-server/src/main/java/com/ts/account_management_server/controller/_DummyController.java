package com.ts.account_management_server.controller;

import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class _DummyController {

    @Autowired
    private AccountRepository accountRepository;

    @GetMapping("")
    public boolean sdsind() {
        return accountRepository.existsByLinkedAccountId("6759982531615a1e8a474435");
    }
}
