import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamy/chat_feature/data_source/chat_data_source.dart';
import '../../models/user_model.dart';
import '../../services/Cache_Helper.dart';
import '../model/Message.dart';

// I do the business logic here
// Represented in storing data locally when there is no internet connection
// I store data remotely when there is internet connection
// I need a interface to define my responsibilities
abstract class ChatHandler {
  bool isLoggedin;
  ChatImplement chatImplement;
  CacheData cacheData;

  ChatHandler(
      {required this.chatImplement,
      required this.cacheData,
      this.isLoggedin = false});

  Future<void> sendMessage(MyUser user, String receiverID, String message);

  Stream<MyMessage> getNewMessages(String chatRoomID);
  Future<List<MyMessage>> getOlderMessages(
      String chatRoomID, bool getOld, int limit);
  Future<List<MyMessage>> getLatestMessages(String chatRoomID);
}

class ChatHandlerImplement extends ChatHandler {
  ChatHandlerImplement(
      {required super.chatImplement, required super.cacheData});

  @override
  Future<void> sendMessage(
    MyUser user,
    String receiverID,
    String message,
  ) async {
    final Timestamp timeStamp = Timestamp.now();
    MyMessage newMessage = MyMessage(
      recieverID: receiverID,
      senderID: user.id,
      senderEmail: user.email,
      message: message,
      timeStamp: timeStamp,
    );
    List<String> ids = [user.id, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    await chatImplement.sendMessage(chatRoomID, newMessage);
  }

  @override
  Stream<MyMessage> getNewMessages(String chatRoomID) {
    return chatImplement.getNewMessages(chatRoomID);
  }

  @override
  Future<List<MyMessage>> getOlderMessages(
      String chatRoomID, bool getOld, int limit) async {
    // TODO: implement getOlderMessages
    List<MyMessage> messages =
        await chatImplement.getOlderMessages(chatRoomID, getOld, limit);
    return messages;
  }

  @override
  Future<List<MyMessage>> getLatestMessages(String chatRoomID) async {
    List<MyMessage> messages =
        await chatImplement.getLatestMessages(chatRoomID);
    return messages;
  }
}
