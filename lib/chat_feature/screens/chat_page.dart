import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/chat_feature/widgets/messages_list.dart';
import 'package:streamy/widgets/CustomText.dart';
import 'package:streamy/widgets/CustomTextField.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import '../../services/NotificationHandler/notification_handler.dart';

class ChatPage extends StatefulWidget {
  final MyUser user;
  final String receiverId;
  final String receiverEmail;
  final String chatRoomId;
  String? receiverName;

   ChatPage(
      {super.key,
      required this.user,
      required this.receiverId,
      required this.receiverEmail,
      required this.chatRoomId,
      this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String chatRoomID = "";
  final messagesScrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await Provider.of<ChatController>(context, listen: false).sendMessage(
        widget.user,
        widget.receiverId,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 28, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //appbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        CircleAvatar(
                          maxRadius: 24,
                          child: Text(widget.receiverName == null
                              ? widget.receiverEmail.characters.first
                                  .toUpperCase()
                              : widget.receiverName!.characters.first
                                  .toUpperCase()),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        /////////
                        Expanded(
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.receiverName == null
                                    ? widget.receiverEmail
                                    : widget.receiverName!} ',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "online",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.video_call,
                          size: 32,
                        ),
                        onPressed: () async {
                          String token = await FirebaseFirestore.instance
                              .collection("UserToken")
                              .doc(widget.receiverId)
                              .get()
                              .then((value) => value.data()!["token"]);
                          NotificationHandler.instance.sendPushMessage(
                              token,
                              "user ${widget.user.name} is video calling you",
                              "${widget.user.name}",
                              videoCallChannel,
                              videoCallChannelKey,
                              widget.chatRoomId,
                              widget.user,
                              widget.receiverId,
                              widget.receiverEmail);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CallPage(
                                        chatRoomID: widget.chatRoomId,
                                        channelKey: videoCallChannelKey,
                                      )));
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          size: 32,
                        ),
                        onPressed: () async {
                          String token = await FirebaseFirestore.instance
                              .collection("UserToken")
                              .doc(widget.receiverId)
                              .get()
                              .then((value) => value.data()!["token"]);
                          NotificationHandler.instance.sendPushMessage(
                              token,
                              "user ${widget.user.name} is calling you",
                              "${widget.user.name}",
                              audioCallChannel,
                              audioCallChannelKey,
                              widget.chatRoomId,
                              widget.user,
                              widget.receiverId,
                              widget.receiverEmail);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CallPage(
                                        chatRoomID: widget.chatRoomId,
                                        channelKey: videoCallChannelKey,
                                      )));
                          // Handle button press action (e.g., navigate to settings)
                        },
                      )
                    ],
                  )
                ],
              ),
              // Divider
              const Divider(
                indent: 24,
                endIndent: 24,
              ),
              //msg  list
              Expanded(
                child: MessagesList(
                  user: widget.user,
                  receiverID: widget.receiverId,
                  chatroomID: widget.chatRoomId,
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      height: 62,
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(left: 0, top: 0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: chatTextFieldColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expanded(flex: 1, child: Container()),
          const Expanded(
              flex: 1,
              child: Icon(
                Icons.emoji_emotions_outlined,
                color: SearchBarTextFieldColor,
              )),
          Expanded(
              flex: 5,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                minLines: 1,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Type something...",
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: chatTextFieldColor,
                  hintStyle: TextStyle(color: SearchBarTextFieldColor),
                border: InputBorder.none
                ),
                controller: _messageController,
                keyboardType: TextInputType.text,
              )),
          const Expanded(
            child: Icon(
              Icons.mic,
              color: SearchBarTextFieldColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:4,right: 8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                  heroTag: "chatTag",
                  backgroundColor: focusColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(58)),
                  onPressed: () {
                    sendMessage();
                    Provider.of<ChatController>(context, listen: false)
                        .jumpToBottom();
                  },
                  child: const Icon(
                    Icons.send,
                    size: 24,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
