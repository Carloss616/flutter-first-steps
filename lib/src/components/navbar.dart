import 'package:flutter/material.dart';

class Navbar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const Navbar(this.title, {Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.search),
          ),
          onTap: () {},
        ),
        // InkWell(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: Icon(Icons.dehaze),
        //   ),
        //   onTap: () {},
        // ),
      ],
    );
  }
}
