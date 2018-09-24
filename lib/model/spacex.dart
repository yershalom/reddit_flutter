import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String url = 'https://api.spacexdata.com/v2/launches';

Future<List<Spacex>> fetchLaunches(http.Client client) async {
  final response = await client.get(url);

  return compute(parseLaunches, response.body);
}

List<Spacex> parseLaunches(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Spacex>((json) => Spacex.fromJson(json)).toList();
}

class Spacex {
  final int flightNumber;
  final String missionName;
  final String launchYear;
  final Object links;
  final String patchIcon;
  final String wiki;
  final bool success;

  Spacex({this.flightNumber, this.missionName, this.launchYear, this.links, this.patchIcon, this.success, this.wiki});

  factory Spacex.fromJson(Map<String, dynamic> json) {
    return Spacex(
      flightNumber: json['flight_number'],
      missionName: json['mission_name'],
      launchYear: json['launch_year'],
      links: json['links'],
      patchIcon: json['links']['mission_patch_small'],
      wiki: json['links']['wikipedia'],
      success: json['launch_success']
    );
  }
}