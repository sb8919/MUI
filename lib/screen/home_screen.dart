import 'package:flutter/material.dart';
import 'package:mui/components/MainIntroText.dart';
import '../components/MainFunctionCard.dart';
import '../components/MainScheduleCard.dart';
import '../components/MainSearchBar.dart';
import '../data/MainFunctionList.dart';
import '../components/AppBar/MainAppBar.dart';
import 'package:mui/data/ScheDataList.dart';



class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> functionList = MainFunctionList;

  Future<List<Map<String, dynamic>>> scheduleList() async{
    List<Map<String,dynamic>> cachedData = await loadDataFromCache();
    if (cachedData.isNotEmpty){
      return cachedData;
    }
    final String uri = "https://www.mokpo.ac.kr/www/148/subview.do";
    final List<Map<String,dynamic>> scheData = await getData(uri);
    return scheData;
  }

  bool isDateGreaterThanToday(String dateString) {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    DateTime date = DateTime.parse("$currentYear-$dateString");

    return date.isAfter(currentDate);
  }

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

            FutureBuilder<List<Map<String, dynamic>>>(
              future: scheduleList(),
              builder: (context, snapshot) {
                print(context);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('오류 발생: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> data = snapshot.data ?? [];
                  List<Map<String, dynamic>> filteredData = data.where((schedule) {
                    String dateString = schedule['content'].substring(0, 5).replaceFirst('.','-'); // 앞에서 5자리를 추출하여 날짜 문자열로 사용
                    return isDateGreaterThanToday(dateString);
                  }).toList();
                  int currentPriority = 3;
                  for (var schedule in filteredData) {
                    schedule['priority'] = currentPriority;
                    currentPriority += 1;
                  }
                  return Expanded(
                    child: ListView(
                      children: filteredData.map((schedule) {
                        return MainScheduleCard(
                          date: schedule['date'],
                          day: schedule['day'],
                          title: schedule['title'],
                          content: schedule['content'],
                          priority: schedule['priority'],
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
