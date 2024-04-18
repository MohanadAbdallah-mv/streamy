import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/user_model.dart';
import '../model/Message.dart';
class ChatBubble extends StatefulWidget {
   MyUser user;
   DocumentSnapshot document;
   ChatBubble({super.key,required this.user,required this.document});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    MyMessage message = widget.document.data() as MyMessage;
    var alignment = message.senderID == widget.user.id
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: message.senderID == widget.user.id
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(message.senderEmail),
          SizedBox(
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.blue,
            ),
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
              ),
            ),
          ),
          Text(message.timeStamp.toDate().hour.toString())
        ],
      ),
    );
  }
}
