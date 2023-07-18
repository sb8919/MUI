import 'package:flutter/material.dart';

class ServeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Mokpo Univ Information',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
