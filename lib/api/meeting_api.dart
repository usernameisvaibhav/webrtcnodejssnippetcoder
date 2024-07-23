import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snippetcodervideocall/utils/user.utils.dart';

String MEETING_API_URL = "http://192.168.1.26:4000/api/meeting";

var client = http.Client();
Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {"Content-Type": "application/json"};

  var userId = await loadUserId();
  print("working1");

  var response = await client.post(Uri.parse('$MEETING_API_URL/start'),
      headers: requestHeaders,
      body: jsonEncode({
        "hostId": userId,
        "hostName": "vaibhav2",
        "userId": "uerId",
      }));
  print("working");
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  print("working1");
  print(meetingId);
  var response =
      await http.get(Uri.parse("$MEETING_API_URL/join?meetingId=$meetingId"));
  print("working2");
  print(response.statusCode);
  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }

  throw 0;
}
