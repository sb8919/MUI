import 'package:flutter/material.dart';

import 'IconWithText.dart';

class MenuCard extends StatelessWidget {
  final Map<String, dynamic> menuData;
  final BuildContext context;

  MenuCard(this.menuData, {required this.context});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // BorderRadius
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${menuData['date']} (${menuData['week']})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            IconWithText(icon: Icons.wb_twilight_outlined, text: '조식', iconColor: Colors.amber),
            Text(menuData['breakfast']),
            SizedBox(height: 20),
            IconWithText(icon: Icons.sunny, text: '중식', iconColor: Colors.redAccent),
            Text(menuData['launch']),
          ],
        ),
      ),
    );
  }
}