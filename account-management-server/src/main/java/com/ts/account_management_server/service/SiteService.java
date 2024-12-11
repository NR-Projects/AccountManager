package com.ts.account_management_server.service;

import com.ts.account_management_server.model.database.Site;
import com.ts.account_management_server.repository.SiteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SiteService {

    @Autowired
    private SiteRepository siteRepository;

    public void addSite(Site site) {
        site.setId(null);
        siteRepository.save(site);
    }

    public List<Site> getAllSites() {
        return siteRepository.findAll();
    }

    public void updateSite(Site site) {
        siteRepository.save(site);
    }

    public void deleteSite(String siteId) {
        siteRepository.deleteById(siteId);
    }
}
