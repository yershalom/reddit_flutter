import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  ImageScreenState createState() => new ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  File _image;
  int _direction = 0;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picky'),
        actions:  <Widget>[
          new IconButton(icon: Icon(Icons.add_a_photo), onPressed: getImage),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: _image == null
          ? Center(
          child: Text('No Image Selected'),
        )
          : Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RotatedBox(
                quarterTurns: _direction,
                child: Image.file(_image)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => rotateImage(-1),
                    icon: Icon(Icons.rotate_left),
                  ),
                  IconButton(
                    onPressed: () => rotateImage(1),
                    icon: Icon(Icons.rotate_right),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  rotateImage(int direction) {
    setState(() {
      _direction = _direction + direction;
    });
  }
}
