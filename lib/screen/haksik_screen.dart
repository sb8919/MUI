import 'package:flutter/material.dart';
import 'package:mui/components/AppBar/HaksikBottomAppBar.dart';
import 'package:mui/components/AppBar/MainAppBar.dart';
import 'package:mui/components/haksik/MenuCard.dart';
import 'package:mui/components/uri/HaksikUri.dart';
import 'package:mui/data/HaksikDataList.dart';

void main() {
  runApp(Haksik());
}

class Haksik extends StatefulWidget {
  @override
  _HaksikState createState() => _HaksikState();
}

class _HaksikState extends State<Haksik> {
  int currentIndex = 0; // 초기 페이지를 1번째 페이지("생활관식당")로 설정

  final List<String> pages = ["교내식당", "생활관식당", "BTL"];


  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(),
        body: Column(
          children: [
            HaksikNavBar(
              currentIndex: currentIndex,
              pages: pages,
              onPageChange: (index) {
                setState(() {
                  currentIndex = index;
                  _pageController.animateToPage(
                    currentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
            ),
            Expanded( // Expanded 추가
              child: Padding(
                padding: const EdgeInsets.only(left:8.0, right:8.0),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MenuCardList(uri: SchoolHaksik);
                    } else if (index == 1) {
                      return Text("생활관식당");
                    } else {
                      return Text("BTL");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
