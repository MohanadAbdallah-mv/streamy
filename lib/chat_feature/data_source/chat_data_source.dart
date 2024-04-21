// abstract class Auth{
//
//   register(){}
//   login(){}
// }
//
// class FireCall extends Auth{
//   @override
//   login(String email, String password) async {
//     // I Interact directly with the data layer
//     // Firebase - Local Storage
//     // I need a interface to define my responsibilities
//     return true;
//   }
// }
// class LocalCall extends Auth{
//
// }
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/models/user_model.dart';

abstract class Chat {
  FirebaseFirestore firebaseFirestore;

  Chat({
    required this.firebaseFirestore,
  });

  Future<void> sendMessage(String chatRoomID, MyMessage message);

  Stream<MyMessage> getNewMessages(String chatRoomID);
  Future<List<MyMessage>> getOlderMessages(
      String chatRoomID, bool getOld, int limit);
}

class ChatImplement extends Chat {
  ChatImplement({required super.firebaseFirestore});
  DocumentSnapshot? lastvisible;
  @override
  Future<void> sendMessage(String chatRoomID, MyMessage message) async {
    await firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(message.toJson());
  }

  @override
  Stream<MyMessage> getNewMessages(String chatRoomID) {
    try {
      Query messageRef = firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timeStamp", descending: false)
          .startAfterDocument(lastvisible!);
      return messageRef.snapshots().map((snapshot) => snapshot.docChanges
              .where((change) => change.type == DocumentChangeType.added)
              .map((change) {
            log(change.doc.data().toString());
            return MyMessage.fromJson(
                change.doc.data() as Map<String, dynamic>);
          }).first);
    } catch (e) {
      log(e.toString());
      log("error at stream");
      throw "error";
    }
  }

  // Get the initial 15 latest messages
  Future<List<MyMessage>> getLatestMessages(String chatRoomID) async {
    try {
      Query messageRef = firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timeStamp", descending: true)
          .limit(50);
      List<DocumentSnapshot> docs = await messageRef.get().then((value) {
        lastvisible = value.docs[value.docs.length - 1];
        // log(MyMessage.fromJson(value.docs[value.docs.length - 1].data()
        //         as Map<String, dynamic>)
        //     .message
        //     .toString());
        return value.docs;
      });
      return docs
          .map((e) => MyMessage.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log(e.toString());
      log("error at latestmessages");

      return [];
    }
  }

  @override
  Future<List<MyMessage>> getOlderMessages(
    //todo deal with the document snapshot "define it"
    String chatRoomID,
    bool getOld,
    int limit,
  ) async {
    Query ref = firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .withConverter<MyMessage>(
            fromFirestore: (snapshot, _) =>
                MyMessage.fromJson(snapshot.data()!),
            toFirestore: (mymessage, _) => mymessage.toJson());
    if (lastvisible != null && getOld == true) {
      ref = ref.startAfterDocument(lastvisible!);
    } //limit(limit)
    List<MyMessage> messages = await ref.limit(limit).get().then((value) {
      lastvisible = value.docs[value.size - 1]; //for older messages
      return value.docs.map((e) {
        log("getting older messages in source");
        log(e.data().toString());
        MyMessage message = e.data()! as MyMessage;
        return message;
      }).toList();
    });
    return messages;
  }
}
