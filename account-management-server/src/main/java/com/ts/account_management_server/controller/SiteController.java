package com.ts.account_management_server.controller;

import com.ts.account_management_server.model.database.Site;
import com.ts.account_management_server.service.SiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/site")
public class SiteController {

    @Autowired
    private SiteService siteService;

    @PostMapping("")
    public void addNewSite(@RequestBody Site site) {
        siteService.addSite(site);
    }

    @GetMapping("/all")
    public List<Site> getAllSites() {
        return siteService.getAllSites();
    }

    @PutMapping("")
    public void updateExistingSite(@RequestBody Site site) {
        siteService.updateSite(site);
    }

    @DeleteMapping("/{siteId}")
    public void deleteExistingSite(@PathVariable String siteId) {
        siteService.deleteSite(siteId);
    }
}
