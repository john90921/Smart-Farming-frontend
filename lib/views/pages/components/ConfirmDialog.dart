import 'package:flutter/material.dart';

  Future<bool?> confirmDialog(BuildContext context, String? message) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmation'),
      content: Text(message ?? 'Are you sure you want to delete?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    ),
  );
}
