import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          'stun:stun3.l.google.com:19302',
          'stun:stun4.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  MediaStream? stream;
  Future<String> createRoom(
      RTCVideoRenderer remoteRenderer, String chatRoomID) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("Rtc_Room")
        .doc();

    log('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      log(track.kind ?? "null", name: "track kind");
      log(track.label ?? "null", name: "track label");
      print("${(localStream?.getAudioTracks())} audio track");
      print("${(localStream?.getVideoTracks())} video track");
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      log('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    log('Created offer: $offer');

    var roomId = roomRef.id;
    await roomRef.set(
        {"call_ID": roomId, "offer": offer.toMap(), "time": DateTime.now()});

    log('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      log('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        log('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      log('Got updated room: ${snapshot.data()}');

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        log("Someone tried to connect");
        await peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          log('Got new remote ICE candidate: ${jsonEncode(data)}');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<void> joinRoom(
      String call_ID, String chatRoomID, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    log(chatRoomID, name: "chat Room id - Signaling Controller -");
    QuerySnapshot<Map<String, dynamic>> callIdDocument = await db
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("Rtc_Room")
        .orderBy("time", descending: true)
        .get();
    String callID = (callIdDocument.docs.first.data())["call_ID"];
    log(call_ID, name: "call_id id - Signaling Controller -");
    DocumentReference roomRef = db
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("Rtc_Room")
        .doc(callID);
    var roomSnapshot = await roomRef.get();
    log('Got room ${roomSnapshot}');

    if (roomSnapshot.exists) {
      log('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          log('onIceCandidate: complete!');
          return;
        }
        log('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        log('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          log('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      log('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      log('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          log(data.toString());
          log('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    final status2 = await Permission.microphone.request();

    if (status.isGranted) {
      // Access camera here
      log("access granted", name: "requestCameraPermission");
    } else if (status.isDenied) {
      // Explain to user why permission is needed and offer to retry
      log("access isDenied", name: "requestCameraPermission");
    } else if (status.isPermanentlyDenied) {
      // Open app settings to allow permission
      log("access isPermanentlyDenied", name: "requestCameraPermission");
    }
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    await requestCameraPermission();
    stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localVideo.srcObject = stream;
    localStream = stream;
    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  void muteAudio() {
    if (localStream != null && localStream!.getAudioTracks().isNotEmpty) {
      localStream!.getAudioTracks().forEach((element) {
        element.enabled = !element.enabled; // Toggle mute state
      });
    } else {
      // Handle no audio track scenario (e.g., permission not granted)
      log("No audio track found in local stream", name: "MuteAudio");
    }
    // Update UI (mute button icon) based on muted state
  }

  void enableVideo() {
    if (localStream != null && localStream!.getVideoTracks().isNotEmpty) {
      localStream!.getVideoTracks().forEach((element) {
        element.enabled = !element.enabled; // Toggle mute state
      });
    } else {
      // Handle no audio track scenario (e.g., permission not granted)
      log("No audio track found in local stream", name: "MuteAudio");
    }
    // Update UI (mute button icon) based on muted state
  }

  Future<void> hangUp(
    RTCVideoRenderer localVideo,
    String chatRoomID,
  ) async {
    try {
      if (stream != null) {
        stream!.dispose();
      }
      if (localStream != null) {
        localStream!.getTracks().forEach((track) {
          track.stop();
        });
      }
      List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
      tracks.forEach((track) {
        track.stop();
      });

      if (remoteStream != null) {
        remoteStream!.getTracks().forEach((track) => track.stop());
      }
      if (peerConnection != null) peerConnection!.close();

      if (roomId != null) {
        var db = FirebaseFirestore.instance;
        //todo update the ref and get callid
        var roomRef = db
            .collection('chat_rooms')
            .doc(chatRoomID)
            .collection("Rtc_Room")
            .doc();
        var calleeCandidates =
            await roomRef.collection('calleeCandidates').get();
        calleeCandidates.docs
            .forEach((document) => document.reference.delete());

        var callerCandidates =
            await roomRef.collection('callerCandidates').get();
        callerCandidates.docs
            .forEach((document) => document.reference.delete());

        await roomRef.delete();
      }

      localStream!.dispose();
      remoteStream?.dispose();
    } catch (e) {
      log(e.toString(), name: "found error");
    }
  }

  void registerPeerConnectionListeners({bool shutdown = false}) {
    RTCIceGatheringState? lastIceGatheringState;
    RTCPeerConnectionState? lastPeerConnectionState;
    RTCSignalingState? lastSignalingState;

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (lastPeerConnectionState != state) {
        log('Connection state change: $state');
        lastPeerConnectionState = state;
      }
      log(state.name);
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      if (lastSignalingState != state) {
        log('on signaling state changed: $state');
        lastSignalingState = state;
      }
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      if (lastIceGatheringState != state) {
        log('ICE gathering state changed: $state');
        lastIceGatheringState = state;
      }
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      log("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
