import 'package:flutter/material.dart';

snackBar(String msg, BuildContext context) {
  final theme = Theme.of(context);
  if (msg.isNotEmpty) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      backgroundColor: theme.primaryColorDark,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
