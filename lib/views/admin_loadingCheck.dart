import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/NotificationHandler/notification_handler.dart';
import 'admin_page.dart';
import 'bottom_navigation.dart';

class AdminCheckPage extends StatefulWidget {
  MyUser user;

  AdminCheckPage({super.key, required this.user});

  @override
  State<AdminCheckPage> createState() => _AdminCheckPageState();
}

class _AdminCheckPageState extends State<AdminCheckPage> {
  String? mtoken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      if(mounted){
        log("${widget.user.role}");
        //todo initmessage here
        //requestPermission();
        //   getToken();
        if (widget.user.role == "admin") {
          NotificationHandler.instance.getToken(widget.user.role);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (context) => AdminPage(user: widget.user)),
                  (route) => false);
        } else {
          log("user");
          NotificationHandler.instance.getToken(widget.user.id);
          log("done with token now navigating to mainhome");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MainHome(user: widget.user)),
                  (route) => false);
          log("shouldn't print");
        }
      }
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true);
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print("user granted permission");
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print("user granted provisional permission");
  //   } else {
  //     print("user declined or didn't accept permissions");
  //   }
  // }
  //
  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       mtoken = token;
  //       print("my token is $mtoken");
  //     });
  //     saveToken(mtoken!);
  //   });
  // }
  //
  // void saveToken(String token) async {
  //   if(widget.user.role=="admin"){
  //     await FirebaseFirestore.instance
  //         .collection("UserToken")
  //         .doc(widget.user.role)
  //         .set({"token": token});
  //   }else{
  //     await FirebaseFirestore.instance
  //         .collection("UserToken")
  //         .doc(widget.user.id)
  //         .set({"token": token});
  //   }
  // }
  //
  // void sendPushMessage(String token, String body, String title) async {
  //   Dio dio = Dio();
  //   try{
  //     await dio.post(
  //       'https://fcm.googleapis.com/v1/projects/ecommerece-c1601/messages:send',
  //       options: Options(
  //         headers: <String, String>{
  //           "Authorization": "Bearer ${ApiKeys.fcmServerKey}",
  //          // "Content-Type": "application/json"
  //         },
  //       ),
  //       data: jsonEncode(
  //         <String, dynamic>{
  //          "priority": "high",
  //           "data": <String, dynamic>{
  //             "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //             "status": "done",
  //             "body": body,
  //             "title": title,
  //           },
  //           "message":{
  //             "token": token,
  //             "notification": <String, dynamic>{
  //               "title": title,
  //               "body": body,
  //               "android_channel_id": "Shoppie"
  //             }
  //           },
  //           // "data":{"story_id":"story_12345"},
  //           "android": {
  //             "notification": {
  //               "click_action": "TOP_STORY_ACTIVITY"
  //             }
  //           },
  //           "apns": {
  //             "payload": {
  //               "aps": {
  //                 "category" : "NEW_MESSAGE_CATEGORY"
  //               }
  //             }
  //           }
  //         },
  //       ),
  //     );
  //   }catch(e){
  //     log(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
  }
}
