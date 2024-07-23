import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  ControlPanel(
      {super.key,
      this.videoEnabled,
      this.audioEnabled,
      this.isConnectionFailed,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReconnect,
      this.onMeetingEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey,
        height: 60,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildControls()));
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(
            videoEnabled! ? Icons.videocam : Icons.videocam_off,
          ),
          color: Colors.white,
          iconSize: 32,
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(
            audioEnabled! ? Icons.mic : Icons.mic_off,
          ),
          color: Colors.white,
          iconSize: 32,
        ),
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          child: IconButton(
            icon: Icon(Icons.call_end),
            onPressed: onMeetingEnd,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
        ),
      ];
    } else {
      return <Widget>[
        ElevatedButton(onPressed: onReconnect, child: Text("Reconnect")),
      ];
    }
  }
}
