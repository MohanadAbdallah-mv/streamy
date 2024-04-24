import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/chat_feature/widgets/messages_list.dart';
import 'package:streamy/widgets/CustomTextField.dart';

import '../../constants.dart';
import '../../models/user_model.dart';

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CallPage(chatRoomID: widget.chatRoomId)));
              // Handle button press action (e.g., navigate to settings)
              print('Settings button pressed');
            },
          ),
        ],
        title: Center(
          child: Text(
            widget.receiverEmail,
            style: TextStyle(
                color: AppTitleColor,
                fontWeight: FontWeight.w400,
                fontSize: 22.sp),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
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
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          headerText: "",
          hint: "Enter Message",
          textEditingController: _messageController,
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
    );
  }
}
