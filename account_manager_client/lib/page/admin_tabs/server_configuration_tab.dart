import 'package:account_manager_client/model/domain/server_config_model.dart';
import 'package:account_manager_client/service/server_config_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ServerConfigurationTab extends StatefulWidget {
  final ServerConfigService serverConfigService;
  const ServerConfigurationTab(
      {super.key,
      required this.serverConfigService});

  @override
  State<ServerConfigurationTab> createState() => _ServerConfigurationTabState();
}

class _ServerConfigurationTabState extends State<ServerConfigurationTab> {
  ServerConfig serverConfig = ServerConfig.emptyConfig();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final fetchedServerConfig =
        await widget.serverConfigService.getServerConfig();
    setState(() {
      serverConfig = fetchedServerConfig;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildServerConfigurationDetails(),
          const SizedBox(height: 20),
          _buildActionList(),
        ],
      ),
    );
  }

  // Modular method to build server configuration details
  Widget _buildServerConfigurationDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Server Configuration",
                    style: Theme.of(context).textTheme.headlineMedium),
                ElevatedButton.icon(
                  onPressed: initializeData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const Divider(),
            _buildConfigurationRow("ID", serverConfig.id),
            _buildConfigurationRow(
                "Master Password", serverConfig.masterPassword),
            _buildConfigurationRow(
              "Guest Request Access",
              serverConfig.guestRequestState ? "Yes" : "No",
            ),
            _buildConfigurationRow(
              "Last Updated",
              "${serverConfig.lastUpdated.toLocal()}".split(' ')[0],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build individual rows for configuration details
  Widget _buildConfigurationRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Modular method to build the action buttons
  Widget _buildActionList() {
    return Column(
      children: [
        ListTile(
          title: const Text('Guest Requests'),
          subtitle: const Text('Enable or disable guest requests'),
          trailing: Switch(
            value: serverConfig.guestRequestState,
            onChanged: submitGuestRequestAccessChange,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showChangeMasterPasswordDialogUI(context),
          child: const Text('Change Master Password'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _viewRegisterSecretsUI(context),
          child: const Text('View All Register Secrets'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showAddRegisterSecretDialogUI(context),
          child: const Text('Add Register Secret'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _clearDataUI(context),
          child: const Text('Clear Database'),
        ),
      ],
    );
  }

  void _viewRegisterSecretsUI(BuildContext context) {
    int currentIndex = 0;

    displayQRCodes(
        BuildContext context, void Function(void Function()) setState) {
      qrCodeDisplayLeftButtonAction() {
        if (currentIndex <= 0) return null;
        setState(() {
          currentIndex--;
        });
      }

      qrCodeDisplayRightButtonAction() {
        if (currentIndex >= serverConfig.deviceRegisterSecrets.length - 1) {
          return null;
        }
          
        setState(() {
          currentIndex++;
        });
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                  data: serverConfig.deviceRegisterSecrets[currentIndex],
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white),
              const SizedBox(height: 16),
              Text(
                'Secret ${currentIndex + 1} of ${serverConfig.deviceRegisterSecrets.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: qrCodeDisplayLeftButtonAction,
                icon: const Icon(Icons.arrow_left),
              ),
              IconButton(
                onPressed: qrCodeDisplayRightButtonAction,
                icon: const Icon(Icons.arrow_right),
              ),
            ],
          )
        ],
      );
    }

    displayNoQRCodes(
        BuildContext context, void Function(void Function()) setState) {
      return const Text("No Register Secrets");
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Register Secrets'),
              content: SizedBox(
                width: 300, // Adjust the size of the dialog content
                height: 350,
                child: (serverConfig.deviceRegisterSecrets.isNotEmpty)
                    ? displayQRCodes(context, setState)
                    : displayNoQRCodes(context, setState),
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
      },
    );
  }

  void _showChangeMasterPasswordDialogUI(BuildContext context) {
    final TextEditingController masterPasswordController = TextEditingController();
  
    Future<void> submitUpdatedMasterPassword() async {
      await widget.serverConfigService.changeMasterPassword(masterPasswordController.text);

      if(!context.mounted) return;
      Navigator.pop(context);
    }
  
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Master Password'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'New Master Password'),
          obscureText: true,
          controller: masterPasswordController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: submitUpdatedMasterPassword,
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showAddRegisterSecretDialogUI(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Register Secret'),
        content: const Text(
          "Are you sure you want to request a new register secret?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              submitRequestToAddRegisterSecret();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _clearDataUI(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear Database'),
        content: const Text(
            'Are you sure you want to clear all data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: submitClearDatabaseAction,
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> submitGuestRequestAccessChange(bool value) async {
    setState(() {
      serverConfig.guestRequestState = value;
    });

    if (value) {
      await widget.serverConfigService.enableGuestRequestState();
    } else {
      await widget.serverConfigService.disableGuestRequestState();
    }
  }

  Future<void> submitRequestToAddRegisterSecret() async {
    await widget.serverConfigService.addNewRegisterSecret();
  }

  void submitClearDatabaseAction() {
    Navigator.pop(context);
  }
}
