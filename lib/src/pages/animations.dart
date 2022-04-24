import 'package:flutter/material.dart';
import 'package:flutter_app/src/components/navbar.dart';

class AnimationsPage extends StatefulWidget {
  final String title;
  AnimationsPage(this.title, {Key key}) : super(key: key);

  @override
  _AnimationsPageState createState() => _AnimationsPageState();
}

class _AnimationsPageState extends State<AnimationsPage> {
  bool fullSize = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(widget.title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.bounceOut,
            color: Colors.blue,
            height: fullSize ? MediaQuery.of(context).size.height : 200,
            width: fullSize ? MediaQuery.of(context).size.width : 200,
            alignment: fullSize ? Alignment.topCenter : Alignment.center,
            child: InkWell(
              child: Text(
                fullSize ? "Contraer" : "Expandir",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  fullSize = !fullSize;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
