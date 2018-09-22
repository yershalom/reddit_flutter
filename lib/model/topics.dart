import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String url = 'https://www.reddit.com';

Future<List<Topics>> fetchTopics(http.Client client) async {
  final response = await client.get("$url/subreddits/default.json");

  return compute(parseTopics, response.body);
}

List<Topics> parseTopics(String responseBody) {
  final parsed = json.decode(responseBody)['data']['children'].cast<Map<String, dynamic>>();

  return parsed.map<Topics>((json) => Topics.fromJson(json['data'])).toList();
}

class Topics {
  final String url;
  final String displayName;
  final String publicDescription;
  final String iconImg;

  Topics({this.url, this.displayName, this.publicDescription, this.iconImg});

  factory Topics.fromJson(Map<String, dynamic> json) {
    return Topics(
        url: json['url'],
        displayName: json['display_name'],
        publicDescription: json['public_description'],
        iconImg: json['icon_img']
    );
  }
}