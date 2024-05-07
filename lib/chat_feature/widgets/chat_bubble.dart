import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:streamy/constants.dart';

import '../../models/user_model.dart';
import '../model/Message.dart';

class ChatBubble extends StatefulWidget {
  bool isSender;
  MyMessage message;
  ChatBubble({super.key, required this.isSender, required this.message});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    MyMessage message = widget.message;
    var alignment =
        widget.isSender ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            widget.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
            child: Text(message.name ?? message.senderEmail),
          ),
          Container(
            margin: widget.isSender
                ? EdgeInsets.only(right: 4, left: 16)
                : EdgeInsets.only(right: 16, left: 4),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: widget.isSender
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r))
                  : BorderRadius.only(
                      bottomRight: Radius.circular(16.r),
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r)),
              color:
                  widget.isSender ? mainBlueColor : messageReceiverColor,
            ),
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: widget.isSender
                ? EdgeInsets.only(right: 8)
                : EdgeInsets.only(left: 8),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: widget.isSender
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  widget.isSender ? "read:${widget.message.read}" : "",
                  //textAlign: TextAlign.start,
                ),
                Text(
                    DateFormat(' hh:mm-aa').format(message.timeStamp.toDate())),
              ],
            ),
          )
        ],
      ),
    );
  }
}
