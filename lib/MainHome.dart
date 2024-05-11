import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamy/views/admin_loadingCheck.dart';
import 'package:streamy/views/onBoarding.dart';

import 'controller/auth_controller.dart';
import 'models/user_model.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    log("MainHome visit again", name: "Main home ");
    Either<String, MyUser> user =
        Provider.of<AuthController>(context, listen: false).getCurrentUser();
    return user.isRight ? AdminCheckPage(user: user.right) : const Intro();
  }
}
