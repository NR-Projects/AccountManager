import 'package:account_management_client/di.dart';
import 'package:account_management_client/routes.dart';
import 'package:flutter/material.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account-Management',
      theme: ThemeData.dark(),
      initialRoute: Routes.accounts,
      routes: Routes.getRoutes(),
    );
  }  
}