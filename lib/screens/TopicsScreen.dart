import 'package:Fluttery/model/topics.dart';
import 'package:Fluttery/screens/PostsScreen.dart';
import 'package:Fluttery/styles/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopicScreen extends StatefulWidget {
  @override
  TopicScreenState createState() => new TopicScreenState();
}

class TopicScreenState extends State<TopicScreen> {

  _renderBody() {
    return FutureBuilder<List<Topics>>(
      future: fetchTopics(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
          ? TopicsList(topics: snapshot.data)
          : Center(child: CircularProgressIndicator());
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit Flutter'),
      ),
      body: _renderBody()
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
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        var image = topics[index].iconImg.length > 0 ? topics[index].iconImg : defaultUrl;
        var title = topics[index].displayName;
        var desc = topics[index].publicDescription;
        final cardIcon = Container(
          padding: const EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(
            vertical: 16.0
          ),
          alignment: FractionalOffset.centerLeft,
          child: Image.network(image, height: 64.0, width: 64.0),
        );
        var cardText = Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                child: new Text(title, style: headerTextStyle),
                padding: EdgeInsets.only(bottom: 15.0),
              ),
              Text(desc.length > 32 ? "${desc.substring(0, 32)}..." : desc)
            ],
          ),
        );
        return InkWell(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => PostScreen(title: title))
            );
          },
          child: Card(
            margin: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Row(
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