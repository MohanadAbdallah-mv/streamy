import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';

class Profile extends StatefulWidget {
  MyUser user;
  Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CustomButton(
                    height: 45,
                    gradient: gradientButton,
                    borderColor: buttonBorderColor,
                    borderRadius: 10,
                    onpress: () {
                      Provider.of<AuthController>(context, listen: false)
                          .logout(widget.user);
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => new MyApp()),
                        (route) => false,
                      );
                    },
                    width: 150,
                    child: const CustomText(
                      text: "Sign Out",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      align: Alignment.center,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
