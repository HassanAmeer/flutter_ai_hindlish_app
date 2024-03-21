import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Logout {
  exit(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text('Are you sure you want to quit?'),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(color: Colors.grey.withOpacity(0.8))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
