import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:snippetcodervideocall/models/meeting_details.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:snippetcodervideocall/pages/home_screen.dart';
import 'package:snippetcodervideocall/utils/user.utils.dart';
import 'package:snippetcodervideocall/widgets/control_panel.dart';
import 'package:snippetcodervideocall/widgets/remote_connections.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage(
      {super.key, this.meetingId, this.name, required this.meetingDetail});
  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": true,
  };

  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: "http://localhost:4000",
      meetingId: widget.meetingDetail.id,
      userId: userId,
      name: widget.name,
    );
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    meetingHelper!.stream = _localStream;
    _localRenderer.srcObject = _localStream;

    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {});
    });
    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("meeting-ended", context, (ev, context) {
      onMeetingEnd();
    });
    meetingHelper!.on("connection-setting-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
      setState(() {});
    });
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHonePage();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _localRenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null
            ? meetingHelper!.connections.isNotEmpty
                ? GridView.count(
                    crossAxisCount:
                        meetingHelper!.connections.length < 3 ? 1 : 2,
                    children: List.generate(meetingHelper!.connections.length,
                        (index) {
                      return Padding(
                        padding: EdgeInsets.all(2),
                        child: RemoteConnection(
                            renderer:
                                meetingHelper!.connections[index].renderer,
                            connection: meetingHelper!.connections[index]),
                      );
                    }),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Waiting for participants to join the meeting",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 24),
                      ),
                    ),
                  )
            : Positioned(
                bottom: 10,
                right: 0,
                child: SizedBox(
                  width: 150,
                  height: 200,
                  child: RTCVideoView(_localRenderer),
                ),
              )
      ],
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  void goToHonePage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }
}
