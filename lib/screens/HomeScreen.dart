import 'package:Fluttery/screens/ImageScreen.dart';
import 'package:Fluttery/screens/SpacexScreen.dart';
import 'package:Fluttery/screens/TopicsScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: TopicScreen(),
            ),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: SpacexScreen(),
            ),
          ),
          new Offstage(
            offstage: index != 2,
            child: TickerMode(
              enabled: index == 2,
              child: ImageScreen(),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
          },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(new AssetImage('assets/reddit.png')),
            title: Text("Reddit")
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/SpaceX-logo.png')),
            title: Text("SpaceX")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text('Picky')
          )
        ])
    );
  }
}