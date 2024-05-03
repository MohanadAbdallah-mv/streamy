import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:streamy/constants.dart';

import '../controller/signaling.dart';

class CallPage extends StatefulWidget {
  String chatRoomID;
  bool? answer;
  String channelKey;
  CallPage(
      {super.key,
      required this.chatRoomID,
      this.answer,
      required this.channelKey});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    roomId = widget.chatRoomID;
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      //setState(() {}); //todo remove and try without setstate
    });
    call();
    super.initState();
  }

  Future<void> call() async {
    bool video = false;
    video = widget.channelKey == videoCallChannelKey ? true : false;
    signaling
        .openUserMedia(_localRenderer, _remoteRenderer, video)
        .then((value) {
      if (widget.answer != null && widget.answer == true) {
        log("answering call", name: "answer");
        signaling.joinRoom(
            widget.chatRoomID, widget.chatRoomID, _remoteRenderer);
        setState(() {});
      } else {
        log("making call", name: "calling");
        signaling.createRoom(_remoteRenderer, widget.chatRoomID);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (_localRenderer.srcObject != null) {
      signaling.hangUp(_localRenderer, widget.chatRoomID);
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CallRoom - WebRTC"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  //   },
                  //   child: const Text("Open camera & microphone"),
                  // ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      roomId = await signaling.createRoom(
                          _remoteRenderer, widget.chatRoomID);
                      textEditingController.text = roomId;
                      setState(() {});
                    },
                    child: const Text("Create room"),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add roomId
                      signaling.joinRoom(
                        roomId,
                        widget.chatRoomID,
                        _remoteRenderer,
                      );
                    },
                    child: const Text("Join room"),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signaling.hangUp(_localRenderer, roomId);
                    },
                    child: const Text("Hangup"),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("press to mute"),
                IconButton(
                  onPressed: () {
                    signaling.muteAudio();
                  },
                  icon: const Icon(Icons.volume_mute_outlined),
                  color: Colors.red,
                )
              ],
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}
