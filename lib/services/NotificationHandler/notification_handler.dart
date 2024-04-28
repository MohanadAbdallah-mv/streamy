import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io' as io;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../access_token_firebase.dart';
import '../../firebase_options.dart';

String? notificationDirection;
dynamic notificationData;

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._private();
  static NotificationHandler get instance {
    return _instance;
  }

  NotificationHandler._private();
  static final AwesomeNotifications awesomeNotifications =
      AwesomeNotifications();
  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await awesomeNotifications.requestPermissionToSendNotifications();
    initFirebaseNotifications();
    initLocalNotifications();
  }

  void getToken(String role) async {
    String? mtoken;
    await FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        mtoken = token;
        log("my token is $mtoken", name: "User Token");
        saveToken(mtoken!, role);
      }
    });
  }

  void saveToken(String token, String role) async {
    print(token);
    print(role);
    if (role == "admin") {
      await FirebaseFirestore.instance
          .collection("UserToken")
          .doc(role)
          .set({"token": token});
      print("finished saving token");
    } else {
      print("token in notification handker $token");
      await FirebaseFirestore.instance
          .collection("UserToken")
          .doc(role) //role in this case is the normal user id
          .set({"token": token});
      print("finished saving token");
    }
  }

  void sendPushMessage(
      String token, String bodymsg, String title, String channelkey) async {
    Dio dio = Dio();
    AccessTokenFirebase tokengenerator = AccessTokenFirebase();
    String Accesstoken = await tokengenerator.getAccessToken();
    String projectID = tokengenerator.projectID;
    try {
      final url =
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $Accesstoken',
      };

      final body = jsonEncode({
        "message": {
          "token": token,
          "data": {"channel": "1", "channelkey": channelkey},
          "notification": {"title": title, "body": bodymsg}
        },
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      log(response.statusCode.toString());
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print("user declined or didn't accept permissions");
    }
  }

  Future initLocalNotifications() async {
    await awesomeNotifications.initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'audioCall',
              channelName: 'AudioCall',
              channelDescription: 'AudioCallTest',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple),
          NotificationChannel(
              channelKey: 'videoCall',
              channelName: 'VideoCall',
              channelDescription: 'videoCallTest',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple),
          NotificationChannel(
              channelKey: 'message',
              channelName: 'message',
              channelDescription: 'chatMessage',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
  }

  void initFirebaseNotifications() async {
    await requestPermission();
    FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("in onMessageOpendApp:${message.contentAvailable}");
    });
  }

  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundMessage: ${message.data}");
    handleNotifications(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: message.data);
  }
  // staticFuture<void> backgroundMessageHandler(RemoteMessage message) async {
  //   //   if (message.notification != null) {
  //   //     _showNotification(message);
  //   //     //direct(message: message);
  //   //   }

  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    print("onMessage: ${message.data}");
    message.notification!.title;
    handleNotifications(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: message.data);
  }

  //
//todo handle channels in handle notification later
  static handleNotifications(
      {required String title,
      required String body,
      required Map<String, dynamic> payload}) {
    _showNotification(
      title,
      body,
      Map<String, String>.from(payload),
    );
  }

  static void _showNotification(
      String title, String body, Map<String, String> payload) {
    log("should show notification now",
        name: "Show Notification at notification handler");
    log(payload.toString());
    switch (payload["channelkey"]) {
      case "message":
        awesomeNotifications.createNotification(
            content: NotificationContent(
                id: -1,
                channelKey: payload["channelkey"]!,
                duration: Duration(seconds: 45),
                title: title,
                body: body));
        break;
      case "videoCall":
        awesomeNotifications.createNotification(
            content: NotificationContent(
                id: 0,
                channelKey: payload["channelkey"]!,
                duration: Duration(seconds: 45),
                title: title,
                body: body,
                wakeUpScreen: true));
        break;
      case "audioCall":
        awesomeNotifications.createNotification(
            content: NotificationContent(
                id: 1,
                channelKey: payload["channelkey"]!,
                duration: Duration(seconds: 45),
                title: title,
                body: body,
                wakeUpScreen: true));
        break;
    }
  }

  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    Map<String, String?>? payload = receivedAction.payload;
  }
}
