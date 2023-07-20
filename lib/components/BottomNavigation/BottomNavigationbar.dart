import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';
import '../../screen/haksik_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    // 각 탭에 해당하는 스크린 위젯을 추가하세요.
    // 예: Screen1(), Screen2(), Screen3(), Screen4()
    HomeScreen(),
    Text('Screen 2'),
    Text('Screen 3'),
    Haksik(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: '공지사항',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert_outlined),
            label: '통학버스',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: '오늘의 학식',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent, // 버튼 클릭시 컬러 변화
        unselectedItemColor: Colors.grey, // 기본 회색 색상
        onTap: _onItemTapped,
      ),
    );
  }
}
