import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../controller/signaling.dart';

class CallPage extends StatefulWidget {
  String chatRoomID;
  CallPage({super.key, required this.chatRoomID});

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
      setState(() {}); //todo remove and try without setstate
    });

    super.initState();
  }

  @override
  void dispose() {
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
                  ElevatedButton(
                    onPressed: () {
                      signaling.openUserMedia(_localRenderer, _remoteRenderer);
                    },
                    child: const Text("Open camera & microphone"),
                  ),
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
                const Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
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
