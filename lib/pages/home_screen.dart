import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippetcodervideocall/api/meeting_api.dart';
import 'package:snippetcodervideocall/models/meeting_details.dart';
import 'package:snippetcodervideocall/pages/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalkey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting User"),
      ),
      body: Form(child: formUI(), key: globalkey),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Welcome",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            // FormHelper.inputFieldWidget(
            //     context, "meetingId", "Enter your meeting Id", (val) {
            //   if (val.isEmpty()) {
            //     return "Meeting Id cant be empty";
            //   }
            //   return null;
            // }, (onSaved) {
            //   meetingId = onSaved;

            // },
            //     borderRadius: 10,
            //     borderFocusColor: Colors.redAccent,
            //     borderColor: Colors.redAccent),
            TextField(
              onChanged: (value) {
                meetingId = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: FormHelper.submitButton("jOIN Meeting", () {
                  if (true) {
                    validateMeeting(meetingId);
                  }
                })),
                Flexible(
                    child: FormHelper.submitButton("Start Meeting", () async {
                  var response = await startMeeting();
                  final body = jsonDecode(response!.body);
                  final meetId = body["data"];

                  validateMeeting(meetId);
                }))
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      print("greatj");

      Response res = await joinMeeting(meetingId);
      print("greatj1");

      var data = jsonDecode(res.body);
      print("greatj $data");
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
//go to joinscreen
      goToJoinScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid meeting Id", "Ok", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JoinScreen(
                  meetingId: meetingDetail.id,
                  meetingDetail: meetingDetail,
                )));
  }

  bool validateAndSave() {
    final form = globalkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
