package com.ts.account_management_server.controller;


import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.factory.AccountFactory;
import com.ts.account_management_server.mapper.AccountMapper;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.dto.AccountRequestDTO;
import com.ts.account_management_server.model.dto.AccountResponseDTO;
import com.ts.account_management_server.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private AccountFactory accountFactory;

    @Autowired
    private AccountService accountService;

    @PostMapping("")
    public void createNewAccount(@RequestBody AccountRequestDTO accountRequestDTO) throws EntityException {
        Account account = accountFactory.getAccountFromDTO(accountRequestDTO);
        accountService.createAccount(account);
    }

    @GetMapping("/all")
    public List<AccountResponseDTO> getAllAccounts() {
        return accountService
                .getAccounts()
                .stream()
                .map(AccountMapper::toDTO)
                .toList();
    }

    @GetMapping("/password/{accountId}")
    public String getAccountPassword(@PathVariable String accountId) throws BaseException {
        Account account = accountFactory.getAccountFromId(accountId);
        return accountService.getPassword(account);
    }

    @PutMapping("")
    public void updateExistingAccount(@RequestBody AccountRequestDTO accountRequestDTO) throws BaseException {
        Account account = accountFactory.getAccountFromDTO(accountRequestDTO);
        accountService.updateAccount(account);
    }

    @DeleteMapping("/account/{accountId}")
    public void deleteExistingAccount(@PathVariable String accountId) throws BaseException {
        accountService.deleteAccount(accountId);
    }
}
