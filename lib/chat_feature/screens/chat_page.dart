import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const CircleAvatar(
                      maxRadius: 24,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "${widget.receiverEmail}",
                          trim: true,
                          trimTo: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          size: 16,
                        ),
                        CustomText(
                          text: "online",
                          color: Colors.green,
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
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
              ]),
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
      // height: 90,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.red),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: CustomTextField(
            headerText: "",
            hint: "Type something...",
            textColor: Colors.white,
            borderFocusColor: Colors.white,
            backGroundColor: chatTextFieldColor,
            textEditingController: _messageController,
            textInputType: TextInputType.text,
            maxlines: 6,
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
