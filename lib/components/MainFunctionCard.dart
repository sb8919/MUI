import 'package:flutter/material.dart';

class MainFunctionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onPressed;

  const MainFunctionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 130,
        height: 155,
        decoration: BoxDecoration(
          color: Colors.white, // 흰색으로 지정
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 35,
              ),
              SizedBox(height: 3.0),
              Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.0),
              Text(content),
              SizedBox(height: 4.0),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onPressed,
                child: Icon(
                  Icons.add,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
