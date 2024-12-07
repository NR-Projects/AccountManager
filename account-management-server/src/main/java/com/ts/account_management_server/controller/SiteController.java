package com.ts.account_management_server.controller;

import com.ts.account_management_server.model.database.Site;
import com.ts.account_management_server.service.SiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/site")
public class SiteController {

    @Autowired
    private SiteService siteService;

    @PostMapping("")
    public void addNewSite(Site site) {
        //
    }
}
