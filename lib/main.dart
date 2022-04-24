import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main App',
      theme: ThemeData(
        primaryColor: Colors.purple[800],
      ),
      home: HomePage(),
    );
  }
}
