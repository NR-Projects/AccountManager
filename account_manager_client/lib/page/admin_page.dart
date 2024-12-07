import 'package:account_manager_client/page/admin_tabs/server_configuration_tab.dart';
import 'package:account_manager_client/page/admin_tabs/user_management_tab.dart';
import 'package:account_manager_client/service/server_config_service.dart';
import 'package:account_manager_client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class AdminPage extends StatelessWidget {
  const AdminPage({super.key, required UserService uservice});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User Management'),
              Tab(text: 'Server Configuration'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserManagementTab(userService: getIt<UserService>()),
            ServerConfigurationTab(serverConfigService: getIt<ServerConfigService>()),
          ],
        ),
      ),
    );
  }
}