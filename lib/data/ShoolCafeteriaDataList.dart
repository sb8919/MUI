import 'dart:convert';
import 'package:http/io_client.dart' as http_io;
import 'package:html/parser.dart' as parser;
import 'dart:io';


void main() async {
  // print('test');
  final ddlist = await getData('https://www.mokpo.ac.kr/www/275/subview.do');

}

Future<List<Map<String, dynamic>>> getData(String uri) async {
  final ioClient = http_io.IOClient(
    HttpClient()..badCertificateCallback = (cert, host, port) => true,
  );
  final response = await ioClient.get(Uri.parse(uri));
  List<Map<String, dynamic>> formattedList = [];
  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final dayList = document.querySelectorAll('._dietListWrap li dl dt');
    final foodList =
        document.querySelectorAll('._dietListWrap li dl dd .contWrap');

    for (var n = 0; n < dayList.length; n++) {
      final weekElements = dayList[n].querySelectorAll('.day');
      final dateElements = dayList[n].querySelectorAll('.date');
      if (weekElements.first.text.trim()=='토'){
        break;
      }
      var breakfast = foodList[n * 2];
      var launch = foodList[n * 2 + 1];
      final breakfastMainElements = breakfast.querySelectorAll(".main");
      final breakfastMenuElements = breakfast.querySelectorAll(".menu");
      final launchMainElements = launch.querySelectorAll(".main");
      final launchMenuElements = launch.querySelectorAll(".menu");

      // print(dateElements.first.text.trim());
      // print(weekElements.first.text.trim());
      // print(breakfastMainElements.first.text.trim());
      // print(breakfastMenuElements.first.text.trim());
      // print(launchMainElements.first.text.trim());
      // print(launchMenuElements.first.text.trim());

      final formattedData = {
        'date': dateElements.first.text.trim(),
        'week': weekElements.first.text.trim(),
        'breakfast': breakfastMainElements.first.text.trim() +
            ', ' +
            breakfastMenuElements.first.text.trim(),
        'launch': launchMainElements.first.text.trim() +
            ', ' +
            launchMenuElements.first.text.trim()
      };
      formattedList.add(formattedData);
    }
    return formattedList;
  } else {
    print('Failed to fetch URL: ${response.statusCode}');
    return [];
  }
}

