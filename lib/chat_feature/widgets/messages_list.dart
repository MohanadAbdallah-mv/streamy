import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/widgets/chat_bubble.dart';

import '../../models/user_model.dart';
import '../controller/chat_controller.dart';
import '../model/Message.dart';
class MessagesList extends StatefulWidget {
  MyUser user;
  String recieverID;
  MessagesList({super.key,required this.user,required this.recieverID});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  Stream<QuerySnapshot<MyMessage>> _chatStream(MyUser user, String reciverID) {
    return Provider.of<ChatController>(context, listen: false)
        .getMessages(user, reciverID);
  }
  @override
  Widget build(BuildContext context) {
    log("entering stream builder");
    return StreamBuilder(
        stream: _chatStream(widget.user, widget.recieverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          log("entering message builder");
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => ChatBubble(user:widget.user, document: doc,))
                .toList(),
          );
        });
  }
}
