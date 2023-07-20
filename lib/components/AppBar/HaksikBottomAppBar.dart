import 'package:flutter/material.dart';

class HaksikNavBar extends StatelessWidget {
  final int currentIndex;
  final List<String> pages;
  final Function(int) onPageChange;

  HaksikNavBar({
    required this.currentIndex,
    required this.pages,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50, // NavBar 높이 설정 (원하는 높이로 변경 가능)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => onPageChange((currentIndex - 1).clamp(0, pages.length - 1)),
          ),
          Text(pages[currentIndex], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () => onPageChange((currentIndex + 1).clamp(0, pages.length - 1)),
          ),
        ],
      ),
    );
  }
}
