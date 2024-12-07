import 'package:account_manager_client/page/admin_page.dart';
import 'package:account_manager_client/page/register_page.dart';
import 'package:account_manager_client/service/auth_service.dart';
import 'package:account_manager_client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'page/auth_page.dart';
import 'page/home_page.dart';
import 'page/settings_page.dart';
import 'page/sites_page.dart';
import 'page/accounts_page.dart';

class Routes {
  static const String auth = '/auth';
  static const String register = '/register';
  static const String home = '/home';
  static const String admin = '/admin';
  static const String settings = '/settings';
  static const String sites = '/sites';
  static const String accounts = '/accounts';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => AuthPage(
        authService: GetIt.instance<AuthService>()
      ),
      register: (context) => RegisterPage(
        userService: GetIt.instance<UserService>()
      ),
      home: (context) => const HomePage(),
      admin: (context) => AdminPage(
        uservice: GetIt.instance<UserService>()
      ),
      settings: (context) => const SettingsPage(),
      sites: (context) => const SitesPage(),
      accounts: (context) => const AccountsPage(),
    };
  }
}
