import 'package:flutter/material.dart';
import 'package:reddit_flutter/screens/topics.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Reddit Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopicScreen(),
    );
  }
}
