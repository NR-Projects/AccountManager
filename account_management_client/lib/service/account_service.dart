import 'dart:convert';

import 'package:account_management_client/constant/app_constants.dart';
import 'package:account_management_client/model/dto/accounts_and_sites.dart';
import 'package:account_management_client/model/entity/account.dart';
import 'package:account_management_client/service/base_service.dart';

class AccountService extends BaseService {

  Future<bool> createAccount(Account account) async {
    final wrappedResponse = await wrappedPostRequest(
      url: AppConstants.Api.Account.CREATE_ACCOUNT,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(account)
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<AccountsAndSites> getAllAccountsAndSites() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.Account.GET_ALL_ACCOUNTS
    );

    if (wrappedResponse.hasErrorOccurred) return AccountsAndSites.initEmpty();

    final response = wrappedResponse.response;

    List<Account> accounts = (response['accountResponseDTOList'] as List<dynamic>)
        .map((item) => Account.fromJson(item as Map<String, dynamic>))
        .toList();

    List<String> siteNames = (response['siteNameList'] as List).map((e) => e.toString()).toList();

    return AccountsAndSites(
      accounts: accounts,
      siteNames: siteNames
    );
  }

  Future<Account> getAccount(String accountId) async {
    final wrappedResponse = await wrappedGetRequest(
      url: "${AppConstants.Api.Account.GET_ACCOUNT}/$accountId"
    );

    if (wrappedResponse.hasErrorOccurred) return Account.initEmpty();

    return Account.fromJson(wrappedResponse.response);
  }

  Future<String> getPassword(String accountId) async {
    final wrappedResponse = await wrappedGetRequest(
      url: "${AppConstants.Api.Account.GET_ACCOUNT_PASSWORD}/$accountId"
    );

    if (wrappedResponse.hasErrorOccurred) return "";

    return wrappedResponse.response['accountPassword'];
  }

  Future<bool> updateAccount(Account account) async {
    final wrappedResponse = await wrappedPutRequest(
      url: AppConstants.Api.Account.UPDATE_ACCOUNT,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(account)
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<bool> deleteAccount(String accountId) async {
    final wrappedResponse = await wrappedDeleteRequest(
      url: "${AppConstants.Api.Account.DELETE_ACCOUNT}/$accountId"
    );

    return !wrappedResponse.hasErrorOccurred;
  }
}