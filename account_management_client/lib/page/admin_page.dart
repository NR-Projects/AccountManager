import 'package:account_management_client/page/admin_tabs/server_configuration_tab.dart';
import 'package:account_management_client/page/admin_tabs/user_management_tab.dart';
import 'package:account_management_client/service/server_info_service.dart';
import 'package:account_management_client/service/user_device_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class AdminPage extends StatelessWidget {
  final UserDeviceService userDeviceService;
  final ServerInfoService serverInfoService;

  const AdminPage({
    super.key,
    required this.userDeviceService,
    required this.serverInfoService
    });

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
            UserManagementTab(userDeviceService: userDeviceService),
            ServerConfigurationTab(serverInfoService: serverInfoService),
          ],
        ),
      ),
    );
  }
}