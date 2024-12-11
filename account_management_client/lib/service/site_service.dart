import 'dart:convert';

import 'package:account_management_client/constant/app_constants.dart';
import 'package:account_management_client/model/entity/site.dart';
import 'package:account_management_client/service/base_service.dart';

class SiteService extends BaseService {
  Future<bool> addNewSite(Site site) async {
    final wrappedResponse = await wrappedPostRequest(
        url: AppConstants.Api.Site.CREATE_SITE,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(site));

    if (wrappedResponse.hasErrorOccurred) return false;
    return true;
  }

  Future<List<Site>> getAllSites() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.Site.GET_ALL_SITES,
    );

    if (wrappedResponse.hasErrorOccurred) return List.empty();

    return (wrappedResponse.response as List<dynamic>)
        .map((item) => Site.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> updateExistingSite(Site site) async {
    final wrappedResponse = await wrappedPutRequest(
        url: AppConstants.Api.Site.UPDATE_SITE,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(site));

    if (wrappedResponse.hasErrorOccurred) return false;
    return true;
  }

  Future<bool> deleteExistingSite(String siteId) async {
    final wrappedResponse = await wrappedDeleteRequest(
      url: "${AppConstants.Api.Site.DELETE_SITE}/$siteId",
    );

    if (wrappedResponse.hasErrorOccurred) return false;
    return true;
  }
}
