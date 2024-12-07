import 'dart:io';
import 'package:account_manager_client/service/user_service.dart';
import 'package:account_manager_client/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class RegisterPage extends StatefulWidget {
  final UserService userService;

  const RegisterPage({super.key, required this.userService});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late UserService userService;

  final TextEditingController _secretCodeController = TextEditingController();
  bool _isUsingQRCode = true; // Determines the current mode (QR vs Manual)
  bool _isSecretKeySaved = false; // Tracks whether a secret key is saved

  @override
  void initState() {
    super.initState();
    userService = widget.userService;
    _checkSecretKeyStatus(); // Check the initial state of the secret key
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(title: 'Register'),
      body: _buildBody(),
    );
  }

  // Body Content
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display secret key status with a refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSecretKeySaved
                    ? 'A secret key is already saved.'
                    : 'No secret key is saved.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: _isSecretKeySaved ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _checkSecretKeyStatus,
                tooltip: 'Refresh secret key status',
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteSecretKey,
                tooltip: 'Delete secret key',
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Toggle Between QR and Manual Entry
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Use QR Code'),
              const SizedBox(width: 8),
              Switch(
                value: _isUsingQRCode,
                onChanged: (bool value) {
                  setState(() {
                    _isUsingQRCode = value;
                  });
                },
              ),
              const SizedBox(width: 8),
              const Text('Enter Manually'),
            ],
          ),
          const SizedBox(height: 20.0),

          // Conditionally Render QR or Manual Input
          _isUsingQRCode ? _buildQRMode() : _buildManualMode(),
        ],
      ),
    );
  }

  // QR Mode Widget
  Widget _buildQRMode() {
    if (Platform.isWindows) {
      return const Column(
        children: [
          Text(
            'QR Code scanning is not available on Windows.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: _onScanPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: const Text(
        'Scan QR Code',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  // Manual Mode Widget
  Widget _buildManualMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _secretCodeController,
          decoration: InputDecoration(
            labelText: 'Enter Secret Code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _onManualRegisterPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Register with Secret Code',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  // Action when the Scan QR Code button is pressed
  Future<void> _onScanPressed() async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'QR Scan',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 500,
      scanFormat: ScanFormat.ONLY_QR_CODE,
    );

    if (res == null) return;

    // Process the scanned QR code
    _registerWithSecretCode(res);
  }

  // Action when the manual register button is pressed
  void _onManualRegisterPressed() {
    final secretCode = _secretCodeController.text.trim();

    if (secretCode.isEmpty) {
      _showErrorMessage('Please enter a secret code.');
      return;
    }

    // Process the manual secret code
    _registerWithSecretCode(secretCode);
  }

  // Registration with the secret code
  Future<void> _registerWithSecretCode(String secretCode) async {
    bool isRegisterSuccess = await userService.registerUserDevice(secretCode);
    String messageText;
    if (isRegisterSuccess) {
      messageText = "Device Registration is Successful";
    } else {
      messageText = "Device Registration Failed";
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(messageText)),
    );

    // Refresh the secret key status after registration
    _checkSecretKeyStatus();
  }

  // Check the status of the saved secret key
  Future<void> _checkSecretKeyStatus() async {
    bool isSaved = await userService.checkIfSecretExistLocally();

    setState(() {
      _isSecretKeySaved = isSaved;
    });
  }

  // Delete secret key
  Future<void> _deleteSecretKey() async {
    await userService.deleteSecretKey();
  }

  // Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
