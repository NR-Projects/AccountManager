import 'package:flutter/material.dart';

PreferredSizeWidget sharedAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
  );
}
