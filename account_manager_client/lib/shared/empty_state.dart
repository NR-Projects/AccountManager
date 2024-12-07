import 'package:account_manager_client/shared/components.dart';
import 'package:flutter/material.dart';

/// A generic placeholder state for unimplemented pages
class PlaceholderState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(title: 'Unimplemented'),
      body: const Center(
        child: Text("Page not yet implemented."),
      ),
    );
  }
}
