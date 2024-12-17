import 'package:account_management_client/routes.dart';
import 'package:account_management_client/store/app_global_store.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppGlobalStore().removeAuthentication();
              Navigator.pushReplacementNamed(context, Routes.auth);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildMobileLayout(context)
        ),
      ),
    );
  }

  // Mobile layout: Neat buttons stacked vertically
  Widget _buildMobileLayout(BuildContext context) {
    final userDevice = AppGlobalStore().getUserDevice();
    final isAdmin = userDevice != null && userDevice.role == "ADMIN";

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResponsiveButton(context, 'Manage Accounts', Routes.accounts),
          const SizedBox(height: 16),
          _buildResponsiveButton(context, 'Manage Sites', Routes.sites),
          if (isAdmin) ...[
            const SizedBox(height: 16),
            _buildResponsiveButton(context, 'Admin Page', Routes.admin),
          ]
        ],
      ),
    );
  }

  // Reusable button for the mobile layout
  Widget _buildResponsiveButton(
      BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
