import 'package:flutter/material.dart';
import 'package:mui/components/MainIntroText.dart';
import '../components/MainFunctionCard.dart';
import '../components/MainScheduleCard.dart';
import '../components/MainSearchBar.dart';
import '../data/MainFunctionList.dart';
import '../data/SchduleList.dart';
import '../components/AppBar/MainAppBar.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> functionList = MainFunctionList;

  final List<Map<String, dynamic>> scheduleList = ScheduleList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainIntroText(),
            SizedBox(height: 25),
            MainSearchBar(),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: functionList.map((function) {
                  return MainFunctionCard(
                    icon: function['icon'],
                    title: function['title'],
                    content: function['content'],
                    onPressed: () {
                      // Add button pressed
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '학사 일정',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){},
                )
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: scheduleList.map((schedule) {
                  return MainScheduleCard(
                    date: schedule['date'],
                    day: schedule['day'],
                    title: schedule['title'],
                    content: schedule['content'],
                    priority: schedule['priority'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
