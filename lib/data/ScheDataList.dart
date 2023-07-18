import 'dart:convert';
import 'package:http/io_client.dart' as http_io;
import 'package:html/parser.dart' as parser;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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
        'content': resultList[n][0],
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
