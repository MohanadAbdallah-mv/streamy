import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamy/chat_feature/model/Message.dart';

abstract class Chat {
  FirebaseFirestore firebaseFirestore;

  Chat({
    required this.firebaseFirestore,
  });

  Future<void> sendMessage(String chatRoomID, MyMessage message);

  Stream<QuerySnapshot> getNewMessages(
      String chatRoomID, DocumentSnapshot? documentSnapshot);
  Future<List<DocumentSnapshot>> getOlderMessages(
      String chatRoomID, bool getOld, int limit, DocumentSnapshot? snapshot);
  Future<List<DocumentSnapshot>> getLatestMessages(String chatRoomID);
}

class ChatImplement extends Chat {
  ChatImplement({required super.firebaseFirestore});
  @override
  Future<void> sendMessage(String chatRoomID, MyMessage message) async {
    DocumentReference chatRef =
        firebaseFirestore.collection("chat_rooms").doc(chatRoomID);
    await chatRef.collection("messages").add(message.toJson());
    await firebaseFirestore.runTransaction((transaction) async {
      final documentSnapshot = await transaction.get(chatRef);
      var currentUnreadCount = 1;

      if (documentSnapshot.data() != null) {
        log("collection found", name: "collection found");
        Map<String, dynamic> docRefData =
            documentSnapshot.data() as Map<String, dynamic>;
        if (docRefData[message.recieverID] != null) {
          log("field found", name: "field found and will add ");
          log(docRefData[message.recieverID].toString(), name: "sendMessage");
          currentUnreadCount = docRefData[message.recieverID] + 1;
        }
      }
      log("updated");
      transaction.set(chatRef, {
        "users": chatRoomID.split('_'),
        "last_msg": message.message,
        "last_time": message.timeStamp,
        "from_user_id": message.senderID,
        message.senderID: 0,
        "to_user_id": message.recieverID, //todo
        message.recieverID: currentUnreadCount,
      });
      return Future(() => null);
    });
    // final currentUnreadCount = documentSnapshot.data()?["to_msg_num"] ?? 0;
    // await chatRef.update({
    //   "last_msg": message.message,
    //   "last_time": message.timeStamp,
    //   "from_user_id": message.senderID,
    //   "from_msg_num": 0,
    //   "to_user_id": message.recieverID, //todo
    //   "to_msg_num": currentUnreadCount,
    // });
    // await chatRef
  }

  @override
  Stream<QuerySnapshot> getNewMessages(
      String chatRoomID, DocumentSnapshot? documentSnapshot) {
    try {
      Query messageRef = firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timeStamp", descending: false);
      if (documentSnapshot != null) {
        messageRef = messageRef.startAfterDocument(documentSnapshot!);
        return messageRef.snapshots();
      } else {
        return messageRef.snapshots();
      }
    } catch (e) {
      throw "error";
    }
  }

  @override
  Future<List<DocumentSnapshot>> getLatestMessages(String chatRoomID) async {
    try {
      Query messageRef = firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timeStamp", descending: true)
          .limit(15);
      List<DocumentSnapshot> docs = await messageRef.get().then((value) {
        return value.docs;
      });
      return docs;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DocumentSnapshot>> getOlderMessages(
    String chatRoomID,
    bool getOld,
    int limit,
    DocumentSnapshot? lastVisibleSnapShot,
  ) async {
    Query ref = firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: true);
    if (lastVisibleSnapShot != null && getOld == true) {
      ref = ref.startAfterDocument(lastVisibleSnapShot);
    }
    List<DocumentSnapshot> messages =
        await ref.limit(limit).get().then((value) {
      return value.docs;
    });
    return messages;
  }
}
