import 'dart:developer';
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

  const ChatPage(
      {super.key,
      required this.user,
      required this.receiverId,
      required this.receiverEmail,
      required this.chatRoomId});

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
              SizedBox(
                height: 64,
                //width: 690,
                child: Row(
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
                          const CircleAvatar(
                            maxRadius: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.receiverEmail} dsvadmskvdnvkjansdkjnvkjdsanavkknj',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  "online",
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
      height: 80,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(left: 0, top: 0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.red),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 8,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: "Type something...",
                    filled: true,
                    fillColor: chatTextFieldColor,
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.mic),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(48),
                      borderSide: const BorderSide(
                          // color: widget.isError ? null : buttonBorderColor,
                          ),
                    )),
                controller: _messageController,
                keyboardType: TextInputType.text,
              )),
          SizedBox(
            width: 48,
            height: 48,
            child: FloatingActionButton(
                heroTag: "chatTag",
                backgroundColor: focusColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(58)),
                onPressed: () {
                  sendMessage();
                  Provider.of<ChatController>(context, listen: false)
                      .jumpToBottom();
                },
                child: const Icon(
                  Icons.arrow_upward,
                  size: 48,
                )),
          )
        ],
      ),
    );
  }
}
