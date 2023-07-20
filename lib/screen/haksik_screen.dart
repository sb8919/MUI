import 'package:flutter/material.dart';
import 'package:mui/components/AppBar/MainAppBar.dart';
import 'package:mui/data/ShoolCafeteriaDataList.dart';

void main() {
  runApp(Haksik());
}

class Haksik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(),
        body: MenuCardList(),
      ),
    );
  }
}


Future<List<Map<String, dynamic>>> haksikList() async {
  final String uri = "https://www.mokpo.ac.kr/www/275/subview.do";
  final List<Map<String, dynamic>> haksikData = await getData(uri);
  return haksikData;
}
class MenuCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: haksikList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터가 도착하기 전에 로딩 상태를 표시할 수 있습니다.
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


class MenuCard extends StatelessWidget {
  final Map<String, dynamic> menuData;
  final BuildContext context;

  MenuCard(this.menuData, {required this.context});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // BorderRadius
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${menuData['date']} (${menuData['week']})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Icon(Icons.wb_twilight_outlined),
            Text(menuData['breakfast']),
            SizedBox(height: 8),
            Icon(Icons.sunny),
            Text(menuData['launch']),
          ],
        ),
      ),
    );
  }

  Widget _buildMealText(String title, String content) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: content,
          ),
        ],
      ),
    );
  }
}
