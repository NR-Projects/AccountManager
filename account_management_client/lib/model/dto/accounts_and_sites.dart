import 'package:account_management_client/model/entity/account.dart';

class AccountsAndSites {
  List<Account> accounts;
  List<String> siteNames;

  AccountsAndSites({
    required this.accounts,
    required this.siteNames
  });

  factory AccountsAndSites.initEmpty() {
    return AccountsAndSites(accounts: [], siteNames: []);
  }
}