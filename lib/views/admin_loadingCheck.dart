import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streamy/constants.dart';
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
  String? myToken = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        log("${widget.user.role}");
        //todo initmessage here

        if (widget.user.role == "admin") {
          NotificationHandler.instance.getToken(widget.user.role);
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<dynamic>(
                  fullscreenDialog: true,
                  builder: (context) => AdminPage(user: widget.user)),
              (route) => false);
        } else {
          NotificationHandler.instance.getToken(widget.user.id);
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MainHome(user: widget.user)),
              (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: SpinKitThreeBounce(
      color: focusColor,
      size: 50,
    )));
  }
}
