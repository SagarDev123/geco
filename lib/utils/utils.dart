import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static void exitUser(BuildContext context, Function(bool) onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(false); // Call the onConfirm function with false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(true); // Call the onConfirm function with true
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
