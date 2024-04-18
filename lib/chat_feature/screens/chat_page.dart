import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/chat_feature/widgets/chat_bubble.dart';
import 'package:streamy/chat_feature/widgets/messages_list.dart';
import 'package:streamy/widgets/CustomTextField.dart';

import '../../constants.dart';
import '../../models/user_model.dart';

class ChatPage extends StatefulWidget {
  MyUser user;
  String recieverId;
  String recieverEmail;

  ChatPage(
      {super.key,
      required this.user,
      required this.recieverId,
      required this.recieverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      log("sending message");
      await Provider.of<ChatController>(context, listen: false)
          .sendMessage(widget.user, widget.recieverId, _messageController.text);
      log("clearing controller message");
      _messageController.clear();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(
            widget.recieverEmail,
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
            child: MessagesList(user: widget.user, recieverID: widget.recieverId),
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
          hint: "Enter Meassge",
          textEditingController: _messageController,
        )),
        IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_upward,
              size: 40.sp,
            ))
      ],
    );
  }

`
}
