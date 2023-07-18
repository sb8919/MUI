import 'package:flutter/material.dart';
import 'package:mui/components/AppBar/ServeScreenAppBar.dart';

import '../components/MainScheduleCard.dart';
import '../data/ScheDataList.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ServeScreenAppBar(),
      body: Column(
        children: [
          ScheScreenListView(context),
        ],
      ),
      );
  }
}
