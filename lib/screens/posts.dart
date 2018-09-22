import 'package:flutter/material.dart';
import 'package:reddit_flutter/model/posts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class PostScreen extends StatefulWidget {
  final String title;

  const PostScreen({Key key, this.title}) : super(key: key);
  @override
  PostScreenState createState() => new PostScreenState(this.title);
}

class PostScreenState extends State<PostScreen> {

  final String topic;
  PostScreenState(this.topic);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts from $topic'),
      ),
      body: FutureBuilder<List<Posts>>(
          future: fetchPosts(http.Client(), topic),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PostsList(posts: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}

class PostsList extends StatelessWidget {

  final List<Posts> posts;

  const PostsList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var title = posts[index].title;
          var score = posts[index].score;
          var link = posts[index].permalink;
          var cardContent = new Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(5.0),
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(title),
                new Text(score)
              ],
            ),
          );
          return new InkWell(
            onTap: () {
              _launchURL(context, "https://reddit.com$link");
            },
            child: new Card(
                margin: EdgeInsets.all(5.0),
                child: cardContent
            ),
          );
        }
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
          url,
          option: new CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: new CustomTabsAnimation(
              startEnter: 'slide_up',
              startExit: 'android:anim/fade_out',
              endEnter: 'android:anim/fade_in',
              endExit: 'slide_down',
            ),

          )
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}