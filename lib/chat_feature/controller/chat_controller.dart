import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/models/user_model.dart';

enum Search { addFriend, myFriends }

class ChatController extends ChangeNotifier {
  final ChatHandlerImplement chatRepo;
  Map<String, List<MyMessage>> chatRooms = {};
  List<MyMessage> messages = [];
  DocumentSnapshot? lastVisibleSnapShot; // to get older messages
  bool getOld = false;
  int paginationCounter = 1;
  DocumentSnapshot? loadAfterSnapShot;
  bool isCall = false;
  String? chatRoomId;
  String? channelKey;
  bool? answer;
  List<MyUser> usersList = [];

  ScrollController? chatRoomScrollController;

  ChatController({required this.chatRepo});
  Future<void> sendMessage(
    MyUser user,
    String receiverID,
    String message,
  ) async {
    chatRepo.sendMessage(user, receiverID, message);
  }

  jumpToBottom() {
    chatRoomScrollController!
        .jumpTo(chatRoomScrollController!.position.minScrollExtent);
  }

  Stream<QuerySnapshot<Object?>> getNewMessages(
    String chatRoomID,
  ) {
    Stream<QuerySnapshot<Object?>> stream =
        chatRepo.getNewMessages(chatRoomID, loadAfterSnapShot);

    return stream;
  }

  set setLoadAfterSnapShot(DocumentSnapshot snapshot) {
    loadAfterSnapShot = snapshot;
    notifyListeners();
  }

  Future<void> getOlderMessages(
    String chatRoomID,
    int limit,
  ) async {
    paginationCounter += 1;
    getOld = true;
    List<DocumentSnapshot> olderMessagesSnapshots =
        await chatRepo.getOlderMessages(
      chatRoomID,
      getOld,
      limit,
      lastVisibleSnapShot,
    );
    log(olderMessagesSnapshots.isNotEmpty.toString(), name: "test");
    if (olderMessagesSnapshots.isNotEmpty) {
      lastVisibleSnapShot =
          olderMessagesSnapshots[olderMessagesSnapshots.length - 1];
      log(lastVisibleSnapShot?.data().toString() ?? "",
          name: "lastVisibleSnapShot");
      loadAfterSnapShot = olderMessagesSnapshots[0];

      List<MyMessage> olderMessages = olderMessagesSnapshots
          .map((e) => MyMessage.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      if (chatRooms.containsKey(chatRoomID)) {
        messages = chatRooms[chatRoomID]!;
        messages.addAll(olderMessages);
      } else {
        messages = [];
        chatRooms[chatRoomID] = messages;
      }
    }

    getOld = false;

    notifyListeners();
  }

  Future<void> getLatestMessages(String chatRoomID) async {
    messages.clear();
    List<DocumentSnapshot> latestMessagesSnapshots =
        await chatRepo.getLatestMessages(
      chatRoomID,
    );
    if (latestMessagesSnapshots.isEmpty) return;
    lastVisibleSnapShot =
        latestMessagesSnapshots[latestMessagesSnapshots.length - 1];
    loadAfterSnapShot = latestMessagesSnapshots[0];

    List<MyMessage> latestMessages = latestMessagesSnapshots
        .map((e) => MyMessage.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    messages.addAll(latestMessages);
    chatRooms[chatRoomID] = messages;
    notifyListeners();
  }

  Future<void> seeMsg(String receiverId, String chatRoomID) async {
    final query = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('senderID', isEqualTo: receiverId)
        .where('read', isEqualTo: false)
        .get();

    query.docs.forEach((doc) {
      doc.reference.update({'read': true});
    });
  }

  void markReadLocal() {
    log("marking loacl message read", name: "markReadLocal");
    messages.first.read = true;
    notifyListeners();
  }

  Future<void> searchFriend(Search search, String email) {
    usersList.clear();
    switch (search) {
      case Search.addFriend:
        FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            usersList.add(MyUser.fromJson(value.docs.first.data()));
            notifyListeners();
            BotToast.showText(
                text: "Sent Friend Request", contentColor: Colors.green);
          } else {
            BotToast.showText(
                text: "Couldn't find User", contentColor: Colors.redAccent);
          }
        });
        break;
      case Search.myFriends:
        break;
    }
    return Future(() => null);
  }
}
