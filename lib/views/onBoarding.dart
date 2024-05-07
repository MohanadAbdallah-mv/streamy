import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streamy/main.dart';

import '../constants.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';
import 'Login.dart';
import 'Signup.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 64),
          child: SizedBox(
            height: 690,
            child: Stack(children: [
              Positioned(
                top: 158,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: 354,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: 76),
                      const Padding(
                        padding: EdgeInsets.only(top: 138),
                        child: CustomText(
                          text: "Welcome!",
                          color: Colors.white,
                          size: 34,
                          align: Alignment.center,
                          fontWeight: FontWeight.w800,
                          fontfamily: "ReadexPro-Bold",
                        ),
                      ),
                      // SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: CustomText(
                          text:
                              "Where online shopping is much easier all you need in one place",
                          size: 16,
                          color: Colors.white,
                          align: Alignment.center,
                        ),
                      ),
                      // SizedBox(height: 46),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 82, left: 16, right: 16),
                        child: CustomButton(
                          onpress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          gradient: gradientButton,
                          borderColor: buttonBorderColor,
                          height: 45,
                          borderRadius: 10,
                          child: const CustomText(
                            text: "Login",
                            color: Colors.white,
                            align: Alignment.center,
                            fontWeight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const CustomText(
                        text: "or",
                        color: Colors.white,
                        align: Alignment.center,
                        size: 17,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: CustomButton(
                          onpress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          gradientBorder: gradientButton,
                          buttonBackgroundColor: Colors.white,

                          thickness: 1,
                          color: Colors.white70,
                          borderColor: buttonBorderColor,
                          height: 45,
                          borderRadius: 10,

                          //color: primaryColor,

                          child: const CustomText(
                            text: "Sign Up",
                            color: focusColor,
                            align: Alignment.center,
                            fontWeight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 17,
                child: SizedBox(
                  height: 208,
                  width: 265.74.w,
                  child: SvgPicture.asset("assets/svg/chat-svgrepo-com.svg"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
