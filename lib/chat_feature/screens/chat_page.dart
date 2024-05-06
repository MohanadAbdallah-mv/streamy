import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/chat_feature/widgets/messages_list.dart';
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBackGroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
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
          ),
          IconButton(
            icon: Icon(Icons.notification_add),
            onPressed: () async {},
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () async {
              String token = await FirebaseFirestore.instance
                  .collection("UserToken")
                  .doc(widget.receiverId)
                  .get()
                  .then((value) => value.data()!["token"]);
              NotificationHandler.instance.sendPushMessage(
                  token,
                  "user ${widget.user.name} is video calling you",
                  "body",
                  videoCallChannel,
                  videoCallChannelKey,
                  widget.chatRoomId,
                  widget.user,
                  widget.receiverId,
                  widget.receiverEmail);
            },
          )
        ],
        title: Center(
          child: Text(
            widget.receiverEmail,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22.sp),
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
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
    );
  }

  Widget _buildMessageInput() {
    return Container(
      //height: 120.h,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r), color: chatTextFieldColor),
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
            textEditingController: _messageController,
            textInputType: TextInputType.text,
            maxlines: 6,
          )),
          IconButton(
              onPressed: () {
                sendMessage();
                Provider.of<ChatController>(context, listen: false)
                    .jumpToBottom();
              },
              icon: Icon(
                Icons.arrow_upward,
                size: 40.sp,
              ))
        ],
      ),
    );
  }
}
