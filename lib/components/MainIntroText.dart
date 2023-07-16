import 'package:flutter/material.dart';
class MainIntroText extends StatelessWidget {
  const MainIntroText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상붐님 안녕하세요!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left:6),
          child: Text(
            '오늘은 수업이 3개 있어요!',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

