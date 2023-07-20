import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final String text;
  final Color iconColor;
  final IconData icon;

  const IconWithText({Key? key, required this.text, required this.iconColor, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}