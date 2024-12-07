import 'package:account_manager_client/routes.dart';
import 'package:account_manager_client/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:account_manager_client/shared/components.dart';

class AuthPage extends StatefulWidget {
  final AuthService authService;

  const AuthPage({super.key, required this.authService});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _masterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(title: 'Authentication'),
      body: _body(),
    );
  }

  Future<void> onAttemptAuthentication() async {

    final password = _masterPasswordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter master password!')),
      );
      return;
    }

    bool isAuthenticationSuccessful = await widget.authService.attemptAuthentication(password);
    String message;
    if (isAuthenticationSuccessful) {
      message = "Authentication Success";
    } else {
      message = "Authentication Failed";
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    if (isAuthenticationSuccessful) {
      Navigator.pushNamed(context, Routes.home);
    }
  }

  Widget _body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Master Password',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _masterPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Master Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAttemptAuthentication,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 10),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.register);
                },
                child: const Text(
                  'Register your device here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
