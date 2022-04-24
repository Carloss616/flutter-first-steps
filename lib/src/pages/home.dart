import 'package:flutter/material.dart';
import 'package:flutter_app/src/components/menuDrawer.dart';
import 'package:flutter_app/src/components/navbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: Navbar('Inicio'),
      body: Center(
        child: Text('Navega'),
      ),
    );
  }
}
