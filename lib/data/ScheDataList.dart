import 'dart:convert';
import 'package:http/io_client.dart' as http_io;
import 'package:html/parser.dart' as parser;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mui/components/MainScheduleCard.dart';

Future<List<Map<String, dynamic>>> getData(String uri) async {
  final ioClient = http_io.IOClient(
    HttpClient()..badCertificateCallback = (cert, host, port) => true,
  );

  final response = await ioClient.get(Uri.parse(uri));
  if (response.statusCode == 200) {
    final document = parser.parse(response.body);

    final scheList = document.querySelectorAll('.scheList');
    List<List<dynamic>> resultList = [];

    for (var sche in scheList) {
      final dayElements = sche.getElementsByTagName('dt');
      final contentsElements = sche.getElementsByTagName('dd');

      for (var i = 0; i < dayElements.length; i++) {
        final dayElement = dayElements[i];
        final contentElement = contentsElements[i];

        final daySpan = dayElement.getElementsByTagName('span').first;
        final day = daySpan.text.trim().replaceAll(RegExp(r'\s{2,}'), ' ');
        final content = contentElement.text.trim().replaceAll(RegExp(r'\s{2,}'), ' ');
        resultList.add([day, content]);
      }
    }

    List<Map<String, dynamic>> formattedList = [];
    for (var n = 0; n < resultList.length; n++) {
      final formattedData = {
        'date': resultList[n][0].substring(3, 5),
        'day': resultList[n][0].substring(8,9),
        'title': resultList[n][1],
        'detail_date': resultList[n][0],
        'priority': n + 3,
      };
      formattedList.add(formattedData);
    }

    await saveDataToCache(formattedList);
    return formattedList;
  } else {
    print('Failed to fetch URL: ${response.statusCode}');
    return [];
  }
}


Future<void> saveDataToCache(List<Map<String, dynamic>> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(data);
  await prefs.setString('cachedData', jsonString);
}

Future<List<Map<String, dynamic>>> loadDataFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('cachedData');
  if (jsonString != null) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<Map<String, dynamic>> dataList =
    jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
    return dataList;
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> scheduleList() async {
  List<Map<String, dynamic>> cachedData = await loadDataFromCache();
  if (cachedData.isNotEmpty) {
    return cachedData;
  }
  final String uri = "https://www.mokpo.ac.kr/www/148/subview.do";
  final List<Map<String, dynamic>> scheData = await getData(uri);
  return scheData;
}

bool isDateGreaterThanToday(String dateString) {
  DateTime currentDate = DateTime.now();
  int currentYear = currentDate.year;
  DateTime date = DateTime.parse("$currentYear-$dateString");

  return date.isAfter(currentDate);
}

Widget MainScheduleListView(BuildContext context) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: scheduleList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('오류 발생: ${snapshot.error}');
      } else {
        List<Map<String, dynamic>> data = snapshot.data ?? [];
        List<Map<String, dynamic>> filteredData =
        data.where((schedule) {
          String dateString = schedule['detail_date']
              .substring(0, 5)
              .replaceFirst('.', '-');
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
                detail_date: schedule['detail_date'],
                priority: schedule['priority'],
              );
            }).toList(),
          ),
        );
      }
    },
  );
}

Widget ScheScreenListView(BuildContext context){

  Future<List<Map<String, dynamic>>> scheduleList() async {
    List<Map<String, dynamic>> cachedData = await loadDataFromCache();
    if (cachedData.isNotEmpty) {
      return cachedData;
    }
    final String uri = "https://www.mokpo.ac.kr/www/148/subview.do";
    final List<Map<String, dynamic>> scheData = await getData(uri);
    return scheData;
  }

  Map<String, List<Map<String, dynamic>>> groupDataByMonth(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var schedule in data) {
      String month = schedule['detail_date'].substring(0, 2);
      if (!groupedData.containsKey(month)) {
        groupedData[month] = [];
      }
      groupedData[month]!.add(schedule);
    }
    return groupedData;
  }

  return FutureBuilder<List<Map<String, dynamic>>>(
    future: scheduleList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('오류 발생: ${snapshot.error}');
      } else {
        List<Map<String, dynamic>> data = snapshot.data ?? [];
        Map<String, List<Map<String, dynamic>>> groupedData = groupDataByMonth(data);
        return Expanded(
          child: ListView.builder(
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              String month = groupedData.keys.elementAt(index);
              List<Map<String, dynamic>> monthData = groupedData[month]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,top:10),
                    child: Text(
                      '$month 월',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: monthData.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> schedule = monthData[index];
                        return MainScheduleCard(
                          date: schedule['date'],
                          day: schedule['day'],
                          title: schedule['title'],
                          detail_date: schedule['detail_date'],
                          priority: 1,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    },
  );
}