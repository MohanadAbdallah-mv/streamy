import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/views/admin_loadingCheck.dart';
import 'package:streamy/views/onBoarding.dart';

import 'chat_feature/controller/chat_controller.dart';
import 'controller/auth_controller.dart';
import 'models/user_model.dart';

class MainHome extends StatefulWidget {
  bool isCall;
  MainHome({super.key, required this.isCall});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool isHome = true;
  ReceivedAction? receivedAction;
  void main() async {
    receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
    if (receivedAction?.channelKey == 'call_channel') {
      log("call channgel recieved", name: "MainHome");
      isHome = false;
    } else {
      log("call channael not recieved yet ", name: "MainHome");
      isHome = true;
    }
  }

  @override
  void initState() {
    main();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("MainHome visit again", name: "Main home ");
    Either<String, MyUser> user =
        Provider.of<AuthController>(context, listen: false).getCurrentUser();
    return user.isRight ? AdminCheckPage(user: user.right) : const Intro();
  }
}
