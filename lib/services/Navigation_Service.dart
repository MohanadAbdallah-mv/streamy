import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/main.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  Future<void> pushChat(Map<String, dynamic> arguments) async {
    final navigator = Navigator.of(navigatorKey.currentContext!);
    // await navigator.push(MaterialPageRoute(
    //     builder: (context) => ChatPage(
    //         user: arguments["user"],
    //         receiverId: arguments["receiverId"],
    //         receiverEmail: arguments["receiverEmail"],
    //         chatRoomId: arguments["chatRoomId"])));
    await navigator.push(MaterialPageRoute(
        builder: (context) => CallPage(chatRoomID: arguments["chatRoomId"])));
  }
}
