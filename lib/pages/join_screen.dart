import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippetcodervideocall/models/meeting_details.dart';
import 'package:snippetcodervideocall/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final String? meetingId;
  final MeetingDetail? meetingDetail;
  const JoinScreen({super.key, this.meetingId, this.meetingDetail});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  String userName = "";
  static final GlobalKey<FormState> globalkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
      ),
      body: Form(child: formUI(), key: globalkey),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Text(
            //   "Welcome",
            //   style: TextStyle(color: Colors.black, fontSize: 25),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            TextField(
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: FormHelper.submitButton("Join", () {
                  // if(validateAndSave()){
                  //   // validateMeeting(meetingId);
                  // }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeetingPage(
                                meetingDetail: widget.meetingDetail!,
                                meetingId: widget.meetingId,
                                name: userName,
                              )));
                })),
//               Flexible(child: FormHelper.submitButton("Start Meeting", ()
//               async{
// var response = await startMeeting();
// final body = jsonDecode(response!.body);
// final meetId = body["data"];

// validateMeeting(meetId);

//               }) )
              ],
            )
          ],
        ),
      ),
    );
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
