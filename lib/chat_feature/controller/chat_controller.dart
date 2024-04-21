import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/models/user_model.dart';

class ChatController extends ChangeNotifier {
  final ChatHandlerImplement chatRepo;
  Map<String, List<MyMessage>> chatRooms = {};
  List<MyMessage> messages = [];
  // TODO: Create Stream Variable

  final ScrollController chatRoomScrollController = ScrollController();

  ChatController({required this.chatRepo});
  Future<void> sendMessage(
    MyUser user,
    String receiverID,
    String message,
  ) async {
    chatRepo.sendMessage(user, receiverID, message);
  }

  jumpToBottom() {
    chatRoomScrollController
        .jumpTo(chatRoomScrollController.position.minScrollExtent);
  }

  Stream<MyMessage> getNewMessages(
    String chatRoomID,
  ) {
    Stream<MyMessage> stream = chatRepo.getNewMessages(chatRoomID);

    return stream;
  }

  Future<void> getOlderMessages(
    String chatRoomID,
    bool getOld,
    int limit,
  ) async {
    List<MyMessage> olderMessages =
        await chatRepo.getOlderMessages(chatRoomID, getOld, limit);
    if (chatRooms.containsKey(chatRoomID)) {
      messages = chatRooms[chatRoomID]!;
      messages.addAll(olderMessages);
      notifyListeners();
    } else {
      messages = [];
      chatRooms[chatRoomID] = messages;
    }

    notifyListeners();
  }

  Future<void> getLatestMessages(String chatRoomID) async {
    messages.clear();
    List<MyMessage> latestMessages = await chatRepo.getLatestMessages(
      chatRoomID,
    );
    messages.addAll(latestMessages);
    // Call
    log(messages.last.toJson().toString());
  }
}
