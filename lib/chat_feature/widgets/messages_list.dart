import 'dart:async';
import 'dart:developer';

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
  bool _initialMessagesLoaded = false;
  Stream<MyMessage> _chatStream(MyUser user, String receiverID) {
    Stream messagesStream = Provider.of<ChatController>(context, listen: false)
        .getNewMessages(widget.chatroomID);

    return messagesStream as Stream<MyMessage>;
  }

  late final Future<void> _myFuture;

  @override
  void initState() {
    _myFuture = Provider.of<ChatController>(context, listen: false)
        .getLatestMessages(widget.chatroomID);
    // .then((value) => setState(() {
    //       _initialMessagesLoaded = true;
    //     }));

    _myController = Provider.of<ChatController>(context, listen: false)
        .chatRoomScrollController;
    // TODO: implement initState
    super.initState();
    _myController.addListener(
      () {
        if (_myController.offset >= _myController.position.maxScrollExtent &&
            !_myController.position.outOfRange) {
          Provider.of<ChatController>(context, listen: false)
              .getOlderMessages(widget.chatroomID, true, 5);
          log("List end");
        }
        if (_myController.offset <= _myController.position.minScrollExtent &&
            !_myController.position.outOfRange) {
          log("List top");
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (b) {
        Provider.of<ChatController>(context, listen: false).messages.clear();
      },
      child: FutureBuilder(
          future: _myFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return StreamBuilder<MyMessage>(
              stream: _chatStream(
                widget.user,
                widget.receiverID,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const Text("error");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return !_initialMessagesLoaded
                      ? const CircularProgressIndicator()
                      : const Text('Waiting for new messages...');
                }
                List<MyMessage> messages =
                    Provider.of<ChatController>(context, listen: false)
                        .messages;
                if (Provider.of<ChatController>(context, listen: false)
                    .messages
                    .contains(snapshot.data!)) {
                } else {
                  Provider.of<ChatController>(context, listen: false)
                      .messages
                      .insert(0, snapshot.data as MyMessage);
                }
                return ListView.builder(
                  itemCount: messages.length,
                  controller: _myController,
                  reverse: true,
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      final item = messages[index];
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
              },
            );
          }),
    );
  }
}
