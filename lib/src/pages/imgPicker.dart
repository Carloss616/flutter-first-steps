import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/src/components/navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:torch_mobile/torch_mobile.dart';

enum ImagePickerEnum {
  camera,
  gallery,
}

class ImgPicker extends StatefulWidget {
  final String title;
  ImgPicker(this.title, {Key key}) : super(key: key);

  @override
  _ImgPickerState createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  String prediction = '';
  PickedFile pickedFile;
  Model imageModel;

  @override
  void initState() {
    super.initState();
    //load your model
    try {
      // TorchMobile.loadModel(
      // model: 'assets/mask_model.pt', labels: 'assets/mask_model.txt');
      PyTorchMobile.loadModel("assets/mask_model.pt").then((model) {
        imageModel = model;
        print({model});
      });
    } on PlatformException {
      print("only supported for android so far");
    }
  }

  void _openCamGall(ImagePickerEnum type) async {
    ImagePicker imagePicker = ImagePicker();
    ImageSource source = type == ImagePickerEnum.gallery
        ? ImageSource.gallery
        : ImageSource.camera;
    PickedFile picture = await imagePicker.getImage(source: source);
    setState(() => pickedFile = picture);
    Navigator.pop(context);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _makePrediction() async {
    File file = File(pickedFile.path);
    Image img = Image.file(file);
    String predict;
    // print({imageModel});

    try {
      predict = await TorchMobile.getPrediction(file,
          maxWidth: img.width.round(), maxHeight: img.height.round());
      // prediction = await imageModel.getImagePrediction(file, img.width.round(),
      //     img.height.round(), "assets/mask_model.txt");
    } on PlatformException {
      predict = 'Failed to get prediction.';
    }
    if (!mounted) return;

    setState(() => prediction = predict);
    print({predict});
  }

  Future<void> _showSimpleDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Selecciona una accion"),
        children: [
          SimpleDialogOption(
            child: Text("Toma una foto"),
            onPressed: () => _openCamGall(ImagePickerEnum.camera),
          ),
          SimpleDialogOption(
            child: Text("Selecciona un foto de galeria"),
            onPressed: () => _openCamGall(ImagePickerEnum.gallery),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(widget.title),
      body: Center(
        child: pickedFile != null
            ? Column(
                children: [
                  Image.file(File(pickedFile.path)),
                  FlatButton(
                    onPressed: _makePrediction,
                    child: Text('Procesar'),
                  )
                ],
              )
            : Text("Vacio"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showSimpleDialog,
      ),
    );
  }
}
