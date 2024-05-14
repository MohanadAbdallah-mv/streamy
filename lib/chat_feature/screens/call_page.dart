import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class _CallPageState extends State<CallPage> with TickerProviderStateMixin {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool isSwapped = false;
  bool video = false;

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
    video = widget.channelKey == videoCallChannelKey ? true : false;
    signaling
        .openUserMedia(_localRenderer, _remoteRenderer, true)
        .then((value) {
      widget.channelKey == videoCallChannelKey
          ? true
          : signaling.enableVideo(video);
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
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //camera 1
            Positioned(
                top: 0,
                child: Container(
                  color: buttonBorderColor,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    child: isSwapped
                        ? RTCVideoView(
                            _localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          )
                        : RTCVideoView(
                            _remoteRenderer,
                          ),
                    onTap: () {},
                  ),
                )),
            //camera 2
            Positioned(
                top: 50,
                right: 10,
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: GestureDetector(
                    child: isSwapped
                        ? RTCVideoView(_remoteRenderer)
                        : RTCVideoView(
                            _localRenderer,
                            mirror: true,
                          ),
                    onTap: () {
                      setState(() {
                        isSwapped = !isSwapped;
                      });
                    },
                  ),
                )),
            Positioned(
                bottom: 64,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          video = !video;
                          signaling.enableVideo(video);
                          setState(() {});
                        },
                        icon: signaling.isVideo
                            ? const Icon(Icons.videocam, size: 48)
                            : const Icon(Icons.videocam_off, size: 48),
                      ),
                      IconButton(
                        onPressed: () {
                          signaling.muteAudio();
                          setState(() {});
                        },
                        icon: signaling.muted
                            ? const Icon(Icons.mic_off, size: 48)
                            : const Icon(Icons.mic, size: 48),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat,
                          size: 48,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await signaling
                              .hangUp(_localRenderer, roomId)
                              .then((value) => Navigator.pop(context));
                        },
                        icon: const Icon(
                          Icons.phone_missed_sharp,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
