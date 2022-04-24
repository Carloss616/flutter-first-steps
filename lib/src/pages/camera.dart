import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/components/navbar.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  final String title;
  CameraPage(this.title, {Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras;
  CameraController controller;
  bool loading = true;

  List<dynamic> recognitions;
  // int imageHeight = 0;
  // int imageWidth = 0;
  bool isDetecting = false;

  Future<void> _loadModel() async {
    String res;
    res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
    print(res);
  }

  Future<void> _loadCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => loading = false);

      controller.startImageStream((img) {
        if (!isDetecting) {
          isDetecting = true;
          // int startTime = new DateTime.now().millisecondsSinceEpoch;

          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 127.5,
            imageStd: 127.5,
            numResultsPerClass: 1,
            threshold: 0.4,
          ).then((recog) {
            // int endTime = new DateTime.now().millisecondsSinceEpoch;
            // print("Detection took ${endTime - startTime}");

            setState(() => recognitions = recog);

            isDetecting = false;
          });
        }
      });
    });
  }

  List<Widget> _renderBoxes(List<dynamic> recognitions) {
    Size screen = MediaQuery.of(context).size;
    // var screenH = screen.height;
    var screenW = screen.width;
    var ratio = controller.value.aspectRatio;

    return recognitions.map((re) {
      var _x = re["rect"]["x"];
      var _w = re["rect"]["w"];
      var _y = re["rect"]["y"];
      var _h = re["rect"]["h"];
      var x, y, w, h;

      x = _x * screenW;
      y = _y * (screenW / ratio);
      w = _w * screenW;
      h = _h * (screenW / ratio);

      return Positioned(
        left: max(0, x),
        top: max(0, y),
        width: w,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              width: 3.0,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() => loading = true);
  //     _loadCamera(); //on pause camera is disposed, so we need to call again "issue is only for android"
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadModel().then((_) => _loadCamera());
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final file = await controller.takePicture();

      // If the picture was taken, display it on a new screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imgPath: file.path,
            imgName: file.name,
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar('Camara'),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : Stack(children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
              Stack(
                children:
                    _renderBoxes(recognitions == null ? [] : recognitions),
              )
            ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: loading
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: _takePicture,
            ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imgPath;
  final String imgName;

  const DisplayPictureScreen({Key key, this.imgPath, this.imgName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(imgName)),
      body: Image.file(File(imgPath)),
    );
  }
}
