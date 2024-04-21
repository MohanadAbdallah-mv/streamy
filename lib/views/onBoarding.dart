

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Center(
            child: Text(
          "Shoppie",
          style: GoogleFonts.sarina(
              textStyle:
                  TextStyle(color: AppTitleColor, fontWeight: FontWeight.w400,fontSize: 34.sp)),
        )),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Container(height: 690.h,
          child: Stack(children: [
            Positioned(
              top: 158.h,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(height: 354.h,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   // SizedBox(height: 76.h),
                    Padding(
                      padding: EdgeInsets.only(top: 138.h),
                      child: CustomText(
                        text: "Welcome!",
                        color: Colors.white,
                        size: 34.sp,
                        align: Alignment.center,
                        fontWeight: FontWeight.w800,
                        fontfamily: "ReadexPro-Bold",
                      ),
                    ),
                   // SizedBox(height: 5.h),
                    Padding(
                      padding:  EdgeInsets.only(top:10.h,left: 12, right: 12),
                      child: CustomText(
                        text:
                            "Where online shopping is much easier all you need in one place",
                        size: 16.sp,
                        color: Colors.white,
                        align: Alignment.center,
                      ),
                    ),
                   // SizedBox(height: 46.h),
                    Padding(
                      padding: EdgeInsets.only(top: 82.h,left: 16, right: 16),
                      child: CustomButton(
                        child: CustomText(
                          text: "Log in",
                          color: primaryColor,
                          align: Alignment.center,
                          size: 16.sp,
                        ),
                        onpress: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        borderColor: Colors.white,
                        color: Colors.white,
                      ),
                    ),
                   // SizedBox(height: 12.h),
                    CustomText(
                      text: "or",
                      color: Colors.white,
                      align: Alignment.center,
                      size: 17.sp,
                    ),
                   // SizedBox(height: 12.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: CustomButton(
                        child: CustomText(
                          text: "Sign Up",
                          color: Colors.white,
                          align: Alignment.center,
                          fontWeight: FontWeight.bold,
                          size: 16.sp,
                        ),
                        onpress: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Signup()));
                        },
                        borderColor: Colors.white,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 17.h,
              child: Container(height:208.h ,width:265.74.w ,
                child: SvgPicture.asset("assets/svg/st_l_app.svg"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
