import 'dart:convert';
import 'package:http/io_client.dart' as http_io;
import 'package:html/parser.dart' as parser;
import 'dart:io';
import 'package:flutter/material.dart';

import '../components/haksik/MenuCard.dart';

Future<List<Map<String, dynamic>>> haksikList(String uri) async {
  final List<Map<String, dynamic>> haksikData = await getData(uri);
  return haksikData;
}

class MenuCardList extends StatelessWidget {
  final String uri;

  MenuCardList({required this.uri});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: haksikList(uri),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final haksikData = snapshot.data ?? [];
          return ListView.builder(
            itemCount: haksikData.length,
            itemBuilder: (context, index) {
              return MenuCard(haksikData[index], context: context);
            },
          );
        }
      },
    );
  }
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

