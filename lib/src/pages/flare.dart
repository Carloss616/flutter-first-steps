import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/components/navbar.dart';

class FlarePage extends StatelessWidget {
  final String title;
  const FlarePage(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlareActor(
            'assets/rive_example.flr',
            animation: 'idle',
          ),
        ),
      ),
    );
  }
}
