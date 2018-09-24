import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String url = 'https://www.reddit.com';

Future<List<Posts>> fetchPosts(http.Client client, topic) async {
  final response = await client.get("$url/r/$topic/hot.json");

  return compute(parsePosts, response.body);
}

List<Posts> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody)['data']['children'].cast<Map<String, dynamic>>();

  return parsed.map<Posts>((json) => Posts.fromJson(json['data'])).toList();
}

class Posts {
  final String title;
  final String permalink;
  final String score;

  Posts({this.title, this.permalink, this.score});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      title: json['title'],
      permalink: json['permalink'],
      score: json['score'].toString()
    );
  }
}