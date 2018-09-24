import 'package:Fluttery/model/spacex.dart';
import 'package:Fluttery/styles/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;

class SpacexScreen extends StatefulWidget {
  SpacexScreenState createState() => new SpacexScreenState();
}

class SpacexScreenState extends State<SpacexScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Spacex'),
      ),
      body: FutureBuilder<List<Spacex>>(
        future: fetchLaunches(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
            ? LaunchesList(launches: snapshot.data)
            : Center(child: CircularProgressIndicator());
        })
    );
  }
}

class LaunchesList extends StatelessWidget {
  final List<Spacex> launches;

  const LaunchesList({Key key, this.launches}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: launches.length,
      itemBuilder: (context, index) {
        var name = launches[index].missionName;
        var img = launches[index].patchIcon;
        var wiki = launches[index].wiki;
        var success = launches[index].success;
        var columnContent = Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(name, style: spacexHeader),
                  Tooltip(
                    message: success ? 'Success' : 'Failure',
                    child: Icon(
                      success ? Icons.done : Icons.close,
                      color: success ? Colors.green : Colors.red
                    ),
                  ),
                ],
              ),
              Image.network(img)
            ],
          ),
        );
        return InkWell(
          onTap: () {
            _launchURL(context, wiki);
          },
          child: Card(
            margin: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: columnContent,
          ),
        );
      },
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
