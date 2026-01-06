import 'package:flutter/material.dart';

class DetectionRecord extends StatelessWidget {
  const DetectionRecord({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: Text('Disease : Anthracnose'),
        subtitle: Text('27/06/2024 - 14:30 pm'),
        trailing: IconButton(icon: Icon(icon), color: Colors.grey, onPressed: () {}),

        onTap: () {
          // Navigate to detection records page
        },
      ),
    );
  }
}
