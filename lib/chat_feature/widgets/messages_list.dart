import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/widgets/chat_bubble.dart';

import '../../models/user_model.dart';
import '../controller/chat_controller.dart';
import '../model/Message.dart';

class MessagesList extends StatefulWidget {
  final MyUser user;
  final String receiverID;
  final String chatroomID;

  const MessagesList({
    super.key,
    required this.user,
    required this.receiverID,
    required this.chatroomID,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late ScrollController _myController;
  final bool _initMessagesLoaded = false;
  late final StreamSubscription<List<MyMessage>> _myStream;

  Stream<List<MyMessage>> _chatStream(MyUser user, String receiverID) {
    Stream<QuerySnapshot<Object?>> messagesStreamQuerySnapshots =
        Provider.of<ChatController>(context, listen: false)
            .getNewMessages(widget.chatroomID);

    return messagesStreamQuerySnapshots.map((snapshots) {
      return snapshots.docChanges.where((element) {
        if (element.type == DocumentChangeType.added &&
            element.doc !=
                Provider.of<ChatController>(context, listen: false)
                    .loadAfterSnapShot) {
          Provider.of<ChatController>(context, listen: false)
              .setLoadAfterSnapShot = snapshots.docs.last;
          return true;
        } else {
          return false;
        }
      }).map((e) {
        return MyMessage.fromJson(e.doc.data()! as Map<String, dynamic>);
      }).toList();
    });
  }

  late final Future<void> _myFuture;

  @override
  void initState() {
    ChatController chatController =
        Provider.of<ChatController>(context, listen: false);
    _myFuture =
        chatController.getLatestMessages(widget.chatroomID).then((value) {
      _myStream = _chatStream(
        widget.user,
        widget.receiverID,
      ).listen((event) {
        event.forEach((element) {
          chatController.messages.insert(0, element);
        });
      });
    });

    // Scroll Trigger

    chatController.chatRoomScrollController = ScrollController();
    _myController = chatController.chatRoomScrollController!;
    _myController.addListener(() {
      if (_myController.offset >= _myController.position.maxScrollExtent &&
          !_myController.position.outOfRange) {
        chatController.getOlderMessages(widget.chatroomID, 5);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _myController.dispose();
    _myStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Provider.of<ChatController>(context);
    return PopScope(
      onPopInvoked: (b) {
        chatController.messages.clear();
      },
      child: FutureBuilder(
          future: _myFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: chatController.messages.length,
                controller: _myController,
                reverse: true,
                itemBuilder: (context, index) {
                  if (index < chatController.messages.length) {
                    final item = chatController.messages[index];
                    return ChatBubble(user: widget.user, message: item);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
