import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage {
  late String senderID;
  late String senderEmail;
  late String? name;
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
      this.name});

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "senderEmail": senderEmail,
      "recieverID": recieverID,
      "message": message,
      "timeStamp": timeStamp,
      "name": name,
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
      name: json["name"],
      read: json["read"] ?? true,
    );
  }
}
