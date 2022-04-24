import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/animations.dart';
import 'package:flutter_app/src/pages/camera.dart';
import 'package:flutter_app/src/pages/flare.dart';
import 'package:flutter_app/src/pages/imgPicker.dart';
import 'package:flutter_app/src/pages/maps.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding:
        //     EdgeInsets.zero, // Important: Remove any padding from the ListView.
        children: <Widget>[
          // DrawerHeader(
          //   child: Text('Drawer'),
          //   decoration: BoxDecoration(
          //     color: Colors.purple[800],
          //   ),
          // ),
          ListTile(
            title: Text('Home'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Camara'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage('Camara')),
              );
            },
          ),
          ListTile(
            title: Text('Image Picker'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImgPicker('Image Picker')),
              );
            },
          ),
          ListTile(
            title: Text('Animaciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimationsPage('Animaciones')),
              );
            },
          ),
          ListTile(
            title: Text('Mapas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsPage('Mapas')),
              );
            },
          ),
          ListTile(
            title: Text('Flare'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlarePage('Flare')),
              );
            },
          ),
        ],
      ),
    );
  }
}
