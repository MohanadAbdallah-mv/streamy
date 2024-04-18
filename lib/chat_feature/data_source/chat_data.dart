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

  Chat({required this.firebaseFirestore});

  Future<void> sendMessage(String chatRoomID, MyMessage message);

  Stream<QuerySnapshot> getMessages(String chatRoomID);
}

class ChatImplement extends Chat {
  ChatImplement({required super.firebaseFirestore});

  @override
  Future<void> sendMessage(String chatRoomID, MyMessage message) async {
    await firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(message.toJson());
  }

  @override
  Stream<QuerySnapshot<MyMessage>> getMessages(String chatRoomID) {
     final messageRef=firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages").orderBy("timeStamp",descending: false)
        .withConverter<MyMessage>(
            fromFirestore: (snapshot, _) =>
                MyMessage.fromJson(snapshot.data()!),
            toFirestore: (mymessage,_)=>mymessage.toJson());
     return messageRef.snapshots();
  }
//   @override
//   Future<Either<String, UserCredential>> login(FormUser userForm) async {
//     try {
// // firebaseauth.sendPasswordResetEmail(email: email)
// // firebaseauth.confirmPasswordReset(code: code, newPassword: newPassword)
// // firebaseauth.verifyPasswordResetCode(code)
//
//       final credential = await firebaseauth.signInWithEmailAndPassword(
//           email: userForm.email, password: userForm.password);
//      // log("'user is back again' auth_source");
//       return Right(credential);
//     } on FirebaseAuthException catch (e) {
//     //  log("'log in failure' auth_source");
//       log(e.code);
//       log(e.message.toString());
//       return Left(e.code);
//     }
//   }
}
