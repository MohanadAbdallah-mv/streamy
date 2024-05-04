import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/models/user_model.dart';

class ChatController extends ChangeNotifier {
  final ChatHandlerImplement chatRepo;
  Map<String, List<MyMessage>> chatRooms = {};
  List<MyMessage> messages = [];
  DocumentSnapshot? lastVisibleSnapShot; // to get older messages
  bool getOld = false;
  int paginationCounter = 1;
  DocumentSnapshot? loadAfterSnapShot;

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
    lastVisibleSnapShot =
        olderMessagesSnapshots[olderMessagesSnapshots.length - 1];
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
}
