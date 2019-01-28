import 'dart:async';
import 'dart:io';

import 'package:Fluttery/widgets/SelectedOption.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';

class ImageScreen extends StatefulWidget {
  ImageScreenState createState() => new ImageScreenState();
}

enum FilterOptions {
  None,
  BlackAndWhite,
  Sepia,
  Vignette,
  Emboss,
  Grayscale,
  Smooth,
  Sobel
}

var filters = <String, FilterOptions>{
  'None': FilterOptions.None,
  'B/W': FilterOptions.BlackAndWhite,
  'Sepia': FilterOptions.Sepia,
  'Vignette': FilterOptions.Vignette,
  'Emboss': FilterOptions.Emboss,
  'Grayscale': FilterOptions.Grayscale,
  'Smooth': FilterOptions.Smooth,
  'Sobel': FilterOptions.Sobel
};

var filter = FilterOptions.None;

class ImageScreenState extends State<ImageScreen> {
  File _image;
  int _direction = 0;

  FilterOptions _filterState;

  @override
  void initState() {
    super.initState();
    _filterState = FilterOptions.None;
  }

  Future getImage(source) async {
    ImageSource whichSource = source == 'Gallery' ? ImageSource.gallery : ImageSource.camera;
    var image = await ImagePicker.pickImage(source: whichSource);

    setState(() {
      _image = image;
    });
  }

  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Gallery', icon: Icons.photo_library),
    CustomPopupMenu(title: 'Take a Picture', icon: Icons.camera_alt),
  ];

  @override
  Widget build(BuildContext context) {
    var listOfFilters = List<Widget>();
    filters.forEach((k, v) => listOfFilters.add(FilterButton(_image, k, onTap: () => drawImage(v))));
    var filteredImages = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: listOfFilters
      ),
    );

    void showMenuSelection(CustomPopupMenu choice) {
      getImage(choice.title);
    }

    AppBar appBar = AppBar(
      title: Text('Picky'),
      actions:  <Widget>[
        PopupMenuButton<CustomPopupMenu>(
          elevation: 3.2,
          onCanceled: () {
          },
          onSelected: showMenuSelection,
          icon: Icon(Icons.add_a_photo),
          itemBuilder: (BuildContext context) {
            return choices.map((CustomPopupMenu choice) {
              return PopupMenuItem<CustomPopupMenu>(
                value: choice,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(choice.title),
                    Icon(choice.icon)
                  ],
                ),
              );
            }).toList();
          },
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
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
                child: Container(
                  child: drawImage(_filterState),
                )
              ),
              filteredImages,
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

  drawImage(FilterOptions newFilter) {
    filter = newFilter;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    setState(() {
      _filterState = newFilter;
    });
    if (_filterState == FilterOptions.None) {
      return Image.file(_image,
        fit: BoxFit.fitWidth,
        height: height / 2);
    } else {
      return FilteredImage(_image, _filterState);
    }
  }

  rotateImage(int direction) {
    setState(() {
      _direction = _direction + direction;
    });
  }
}

class FilterButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final File filename;
  final String effect;

  FilterButton(this.filename, this.effect, {this.onTap});

  @override
  Widget build(BuildContext context) {
    var directory = getApplicationDocumentsDirectory();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 2.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent, width: filters[effect] == filter ? 3.0 : 0.0),
                ),
                child: SizedBox(
                  child: FilteredImage(
                    filename,
                    filters[effect]
                  ),
                  height: 55.0,
                  width: 55.0
                ))
            ),
            Text(effect),
          ],
        )
      ),
    );
  }
}

class FilteredImage extends StatelessWidget {
  final File originalFile;
  final FilterOptions filterState;
  static int foo = 0;
  FilteredImage(this.originalFile, this.filterState);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _localPath,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          image.Image unmodifiedImage = image.decodeImage(originalFile.readAsBytesSync());

          image.Image result = unmodifiedImage;
          switch (filterState) {
            case FilterOptions.BlackAndWhite:
              result = image.grayscale(unmodifiedImage);
              break;
            case FilterOptions.Sepia:
              result = image.sepia(unmodifiedImage);
              break;
            case FilterOptions.Vignette:
              result = image.vignette(unmodifiedImage);
              break;
            case FilterOptions.Emboss:
              result = image.emboss(unmodifiedImage);
              break;
            case FilterOptions.Grayscale:
              result = image.grayscale(unmodifiedImage);
              break;
            case FilterOptions.Sobel:
              result = image.sobel(unmodifiedImage);
              break;
            case FilterOptions.Smooth:
              result = image.smooth(unmodifiedImage, 2000);
              break;
            case FilterOptions.None:
            default:
              break;
          }
          snapshot.data
            .writeAsBytesSync(image.encodePng(result));
          return Image.file(snapshot.data,
            fit: BoxFit.cover,
            height: height / 2);
        } else {
          return Image.file(originalFile, fit: BoxFit.cover,
            height: height / 2);
        }
      },
    );
  }

  Future<File> get _localPath async {
    var directory = await getApplicationDocumentsDirectory();
    return File(
      '${directory.path}/$filterState${originalFile.uri.pathSegments.last}.jpg');
  }
}