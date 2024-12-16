package com.ts.account_management_server.controller;


import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.factory.AccountFactory;
import com.ts.account_management_server.mapper.AccountMapper;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.Site;
import com.ts.account_management_server.model.dto.AccountRequestDTO;
import com.ts.account_management_server.model.dto.AccountResponseDTO;
import com.ts.account_management_server.model.dto.AccountsAndSitesDTO;
import com.ts.account_management_server.service.AccountService;
import com.ts.account_management_server.service.SiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private AccountFactory accountFactory;

    @Autowired
    private AccountService accountService;

    @Autowired
    private SiteService siteService;

    @PostMapping("")
    public void createNewAccount(@RequestBody AccountRequestDTO accountRequestDTO) throws Exception {
        Account account = accountFactory.getAccountFromDTO(accountRequestDTO);
        accountService.createAccount(account);
    }

    @GetMapping("/all")
    public AccountsAndSitesDTO getAllAccounts() {
        return AccountsAndSitesDTO
                .builder()
                .accountResponseDTOList(
                        accountService
                                .getAccounts()
                                .stream()
                                .map(AccountMapper::toDTO)
                                .toList()
                )
                .siteNameList(
                        siteService
                                .getAllSites()
                                .stream()
                                .map(Site::getName)
                                .toList()
                )
                .build();
    }

    @GetMapping("/{accountId}")
    public AccountResponseDTO getAccount(@PathVariable String accountId) throws Exception {
        return AccountMapper.toDTOwithSensitiveInfo(accountService.getFullAccount(accountId));
    }

    @GetMapping("/password/{accountId}")
    public Map<String, String> getAccountPassword(@PathVariable String accountId) throws Exception {
        Account account = accountFactory.getAccountFromId(accountId);
        return Map.of(
                "accountPassword", accountService.getPassword(account)
        );
    }

    @PutMapping("")
    public void updateExistingAccount(@RequestBody AccountRequestDTO accountRequestDTO) throws Exception {
        Account account = accountFactory.getAccountFromDTO(accountRequestDTO);
        accountService.updateAccount(account);
    }

    @DeleteMapping("/{accountId}")
    public void deleteExistingAccount(@PathVariable String accountId) throws BaseException {
        accountService.deleteAccount(accountId);
    }
}
