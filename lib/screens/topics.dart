import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_flutter/model/topics.dart';
import 'package:reddit_flutter/screens/posts.dart';
import 'package:reddit_flutter/styles/mainStyle.dart';

class TopicScreen extends StatefulWidget {
  @override
  TopicScreenState createState() => new TopicScreenState();
}

class TopicScreenState extends State<TopicScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit Flutter'),
      ),
      body: FutureBuilder<List<Topics>>(
          future: fetchTopics(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? TopicsList(topics: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}

// With Card view
class TopicsList extends StatelessWidget {
  final List<Topics> topics;
  final String defaultUrl = "https://b.thumbs.redditmedia.com/S6FTc5IJqEbgR3rTXD5boslU49bEYpLWOlh8-CMyjTY.png";

  const TopicsList({Key key, this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          var image = topics[index].iconImg.length > 0 ? topics[index].iconImg : defaultUrl;
          var title = topics[index].displayName;
          var desc = topics[index].publicDescription;
          final cardIcon = new Container(
            padding: const EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(
                vertical: 16.0
            ),
            alignment: FractionalOffset.centerLeft,
            child: new Image.network(image, height: 64.0, width: 64.0),
          );
          var cardText = new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(title, style: headerTextStyle),
                new Text(desc.length > 32 ? "${desc.substring(0, 32)}..." : desc)
              ],
            ),
          );
          return new InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => PostScreen(title: title))
              );
            },
            child: new Card(
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: new Row(
                children: <Widget>[
                  cardIcon,
                  cardText
                ],
              ),
            ),
          );
        }
    );

  }
}