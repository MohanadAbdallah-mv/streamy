import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../access_token_firebase.dart';


String? notificationDirection;
dynamic notificationData;

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._private();

  static NotificationHandler get instance {
    return _instance;
  }

  NotificationHandler._private();
  final _androidChannel = const  AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name or "title"
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    await Firebase.initializeApp();

    initFirebaseNotifications();
    initLocalNotifications();

    // FirebaseMessaging.instance.onTokenRefresh.listen((String? token) async {
    //   if (UserCache.instance.isLoggedIn() && token != null) {
    //     _notificationRepo.updateToken(token);
    //   }
    // });
  }

  void getToken(String role) async {
    String? mtoken;
    await FirebaseMessaging.instance.getToken().then((token) {
        if(token!=null){
          mtoken = token;
          print("my token is $mtoken");
          saveToken(mtoken!,role);
        }});
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
  void saveToken(String token,String role) async {
    if(role=="admin"){
      await FirebaseFirestore.instance
          .collection("UserToken")
          .doc(role)
          .set({"token": token});
      print("finished saving token");
    }else{
      await FirebaseFirestore.instance
          .collection("UserToken")
          .doc(role)        //role in this case is the normal user id
          .set({"token": token});
      print("finished saving token");

    }
  }

  void sendPushMessage(String token, String bodymsg, String title) async {
    Dio dio = Dio();
    AccessTokenFirebase tokengenerator = AccessTokenFirebase();
    String Accesstoken=await tokengenerator.getAccessToken();
    print("accesstoken is before msg $Accesstoken");
    try{
     // Response response= await dio.post(
     //    'https://www.googleapis.com/auth/firebase.messaging',// //https://fcm.googleapis.com/v1/projects/ecommerece-c1601/messages:send
     //    options: Options(
     //      headers: {
     //        "Authorization": "Bearer $Accesstoken",
     //        "Content-Type": "application/json"
     //      },
     //    ),
     //    data: jsonEncode({
     //        "message": {
     //          "token": token,
     //          "notification": {
     //            "title": title,
     //            "body": body,
     //            // "android_channel_id": "Shoppie"
     //          }
     //        },
     //        // "data":{"story_id":"story_12345"},
     //        "android": {
     //          "notification": {
     //            "click_action": "TOP_STORY_ACTIVITY"
     //          }
     //        },
     //        "apns": {
     //          "payload": {
     //            "aps": {
     //              "category": "NEW_MESSAGE_CATEGORY"
     //            }
     //          }
     //        }
     //      }),
     //
     //  );
     final url = 'https://fcm.googleapis.com/v1/projects/ecommerece-c1601/messages:send';

     final headers = {
       'Content-Type': 'application/json',
       'Authorization': 'Bearer $Accesstoken',
     };

     final body = jsonEncode({
       "message": {
         "token": token,
         "notification": {
           "title": title,
           "body": bodymsg,
           //"android_channel_id": "Shoppie"
         }
       },
     });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);
     print(response.statusCode);
    print(response.body);
    }catch(e){
      log(e.toString());
    }
  }

  void initFirebaseNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        RemoteNotification notification = message.notification!;
        if (io.Platform.isAndroid) {
//Creating a new AndroidNotificationChannel instance:

          print(_androidChannel.id);
          print(_androidChannel.name);
          print(_androidChannel.description);

//Creating the channel on the device (if a channel with an id already exists, it will be updated)


          // await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          //     ?.createNotificationChannel(_androidChannel);
//showing notification locally
          AndroidNotification android = message.notification!.android!;
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
              // other properties...
            ),
          ),
          payload: jsonEncode(message.toMap()));

        } else if (io.Platform.isIOS) {
//todo show for ios
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("in onMessageOpendApp:${message.contentAvailable}");
    });

    await requestPermission();

    // getToken().then((String? token) {
    //   assert(token != null);
    //   // ChatManager().fcmToken = token;
    //   print("Push Messaging token: $token");
    // });
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    if (message.notification == null) {
      _showNotification(message);
      //direct(message: message);
    }
  }
static void _showNotification(RemoteMessage message){
    print("implement flutter local notification");
    print(message.data);
}
  Future initLocalNotifications() async{

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload){
        final message =RemoteMessage.fromMap(jsonDecode(payload.payload!));
        print("handle message now");
        });
  final platform= flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(_androidChannel);
  }
  }
//   static Future _showNotification(RemoteMessage message) async {
//     var pushTitle;
//     var pushText;
//     var nodeData;
//
//     String? language = message.data["lang"].toString();
//
//     // if (isChatMessageNotification(message)) {
//     //   if (language == "en") {
//     //     pushTitle = nodeData['title_en'];
//     //     pushText = nodeData['body_en'];
//     //   } else {
//     //     pushTitle = nodeData['title_ar'];
//     //     pushText = nodeData['body_ar'];
//     //   }
//     // } else {
//     //   if (Platform.isAndroid) {
//     //     nodeData = message.data;
//     //     if (language == "en") {
//     //       pushTitle = nodeData['title_en'];
//     //       pushText = nodeData['body_en'];
//     //     } else {
//     //       pushTitle = nodeData['title_ar'];
//     //       pushText = nodeData['body_ar'];
//     //     }
//     //   } else {
//     //     nodeData = message.data;
//     //     if (language == "en") {
//     //       pushTitle = nodeData['title_en'];
//     //       pushText = nodeData['body_en'];
//     //     } else {
//     //       pushTitle = nodeData['title_ar'];
//     //       pushText = nodeData['body_ar'];
//     //     }
//     //   }
//     // }
//
//   //   var platformChannelSpecificsAndroid = new AndroidNotificationDetails(
//   //       '1', 'AerBag',
//   //       channelDescription: 'AerBag New Notifications',
//   //       playSound: true,
//   //       enableVibration: false,
//   //       importance: Importance.max,
//   //       priority: Priority.max,
//   //       icon: "icon");
//   //
//   //   var platformChannelSpecificsIos =
//   //   new DarwinNotificationDetails(presentSound: true);
//   //
//   //   var platformChannelSpecifics = new NotificationDetails(
//   //       android: platformChannelSpecificsAndroid,
//   //       iOS: platformChannelSpecificsIos);
//   //
//   //   new Future.delayed(Duration.zero, () {
//   //     _flutterLocalNotificationsPlugin.show(
//   //       0,
//   //       pushTitle,
//   //       pushText,
//   //       platformChannelSpecifics,
//   //       payload: JsonEncoder().convert(message.data),
//   //     );
//   //   });
//   // }
// }

