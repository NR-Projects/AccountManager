import 'package:account_management_client/page/admin_page.dart';
import 'package:account_management_client/page/auth_page.dart';
import 'package:account_management_client/page/home_page.dart';
import 'package:account_management_client/page/register_page.dart';
import 'package:account_management_client/page/sites_page.dart';
import 'package:account_management_client/page/accounts_page.dart';
import 'package:account_management_client/service/account_service.dart';
import 'package:account_management_client/service/auth_service.dart';
import 'package:account_management_client/service/server_info_service.dart';
import 'package:account_management_client/service/site_service.dart';
import 'package:account_management_client/service/user_device_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes {
  static const String auth = '/auth';
  static const String register = '/register';
  static const String home = '/home';
  static const String admin = '/admin';
  static const String sites = '/sites';
  static const String accounts = '/accounts';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => AuthPage(
        authService: GetIt.instance<AuthService>()
      ),
      register: (context) => RegisterPage(
        userDeviceService: GetIt.instance<UserDeviceService>(),
      ),
      home: (context) => const HomePage(),
      admin: (context) => AdminPage(
        userDeviceService: GetIt.instance<UserDeviceService>(),
        serverInfoService: GetIt.instance<ServerInfoService>(),
      ),
      sites: (context) => SitesPage(
        siteService: GetIt.instance<SiteService>(),
      ),
      accounts: (context) => AccountsPage(
        accountService: GetIt.instance<AccountService>()
      ),
    };
  }
}