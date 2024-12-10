import 'package:account_management_client/model/entity/user_device.dart';
import 'package:account_management_client/service/user_device_service.dart';
import 'package:flutter/material.dart';

class UserManagementTab extends StatefulWidget {
  final UserDeviceService userDeviceService;

  const UserManagementTab({super.key, required this.userDeviceService});

  @override
  State<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<UserManagementTab> {
  List<UserDevice> userDevices = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final fetchedUserDevices = await widget.userDeviceService.getAllUserDevices();
    setState(() {
      userDevices = fetchedUserDevices;
    });
  }

  void refreshTable() {
    initializeData(); // Re-fetch users to refresh the table
  }

  void showUserDetails(UserDevice userDevice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${userDevice.id}'),
                Text('Role: ${userDevice.role}'),
                const Divider(),
                const Text('Device Details:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Device Label: ${userDevice.label}'),
                Text(
                    'Allowed Token Request Count: ${userDevice.allowedTokenRequestCount}'),
                const Divider(),
                const Text('Device Metadata:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...userDevice.metadata.entries.map((entry) {
                  return Text('${entry.key}: ${entry.value}');
                })
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void editUser(UserDevice userDevice) {
    final TextEditingController labelController =
        TextEditingController(text: userDevice.label);
    final TextEditingController tokenCountController = TextEditingController(
        text: userDevice.allowedTokenRequestCount.toString());
    String selectedRole = userDevice.role;

    submitEditUser() async {
      userDevice.label = labelController.text;
      userDevice.allowedTokenRequestCount = int.tryParse(tokenCountController.text) ?? 0;
      userDevice.role = selectedRole;

      bool isUpdateSuccess = await widget.userDeviceService.updateUserDevice(userDevice);

      String message = "User Update Unsuccessful!";
      if (isUpdateSuccess) message = "User Update Successful!";

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User: ${userDevice.label}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Device Label'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['PENDING', 'GUEST', 'ADMIN'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (newRole) {
                  if (newRole != null) selectedRole = newRole;
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: tokenCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Allowed Token Request Count',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: submitEditUser,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(String userId) {
    setState(() {
      userDevices.removeWhere((user) => user.id == userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Management',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: initializeData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: _userTableView())
          ],
        ));
  }

  Widget _userTableView() {
    return Card(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Label')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Actions')),
        ],
        rows: userDevices.map((userDevice) {
          return DataRow(cells: [
            DataCell(
              GestureDetector(
                onTap: () => showUserDetails(userDevice),
                child: Text(userDevice.label,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            DataCell(Text(userDevice.role)),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editUser(userDevice),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(userDevice.id),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }
}
