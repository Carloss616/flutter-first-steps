import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/components/navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final String title;
  MapsPage(this.title, {Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final LatLng fromPoint = LatLng(-38.956176, -67.920666);
  final LatLng toPoint = LatLng(-38.953724, -67.923921);
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(widget.title),
      body: Container(
          // child: GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: fromPoint,
          //       zoom: 16.0,
          //     ),
          //     markers: _createMarkers(),
          //     onMapCreated: _onMapCreated,
          //     ),
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.zoom_out_map),
        onPressed: _centerView,
      ),
    );
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(
      Marker(
        markerId: MarkerId("fromPoint"),
        position: fromPoint,
        infoWindow: InfoWindow(title: "Pizzeria"),
      ),
    );
    tmp.add(
      Marker(
        markerId: MarkerId("toPoint"),
        position: toPoint,
        infoWindow: InfoWindow(title: "Roca 123"),
      ),
    );

    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _centerView();
  }

  _centerView() async {
    await _mapController.getVisibleRegion();

    var left = min(fromPoint.latitude, toPoint.latitude);
    var right = max(fromPoint.latitude, toPoint.latitude);
    var top = max(fromPoint.longitude, toPoint.longitude);
    var bottom = min(fromPoint.longitude, toPoint.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _mapController.animateCamera(cameraUpdate);
  }
}
