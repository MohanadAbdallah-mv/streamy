import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage {
  late String senderID;
  late String senderEmail;
  late String? name;
  late String recieverID;
  late String message;
  late Timestamp timeStamp;

  MyMessage(
      {required this.recieverID,
      required this.senderID,
      required this.senderEmail,
      required this.message,
      required this.timeStamp,
      this.name});

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "senderEmail": senderEmail,
      "recieverID": recieverID,
      "message": message,
      "timeStamp": timeStamp,
      "name": name,
    };
  }

  factory MyMessage.fromJson(Map<String, dynamic> json) {
    return MyMessage(
        recieverID: json["recieverID"],
        senderID: json["senderID"],
        senderEmail: json["senderEmail"],
        message: json["message"],
        timeStamp: json["timeStamp"],
        name: json["name"]);
  }
}
