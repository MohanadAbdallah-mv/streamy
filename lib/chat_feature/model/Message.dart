import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage {
  late String senderID;
  late String senderEmail;
  late String? senderName;
  late String? recieverName;
  late String recieverID;
  late String message;
  bool? read;
  late Timestamp timeStamp;

  MyMessage(
      {required this.recieverID,
      required this.senderID,
      required this.senderEmail,
      required this.message,
      required this.timeStamp,
      this.read = false,
      this.senderName,
      this.recieverName});

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "senderEmail": senderEmail,
      "recieverID": recieverID,
      "message": message,
      "timeStamp": timeStamp,
      "senderName": senderName,
      "recieverName": recieverName,
      "read": read
    };
  }

  factory MyMessage.fromJson(Map<String, dynamic> json) {
    return MyMessage(
      recieverID: json["recieverID"],
      senderID: json["senderID"],
      senderEmail: json["senderEmail"],
      message: json["message"],
      timeStamp: json["timeStamp"],
      senderName: json["senderName"],
      recieverName: json["recieverName"],
      read: json["read"] ?? true,
    );
  }
}
