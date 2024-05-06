import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamy/views/Signup.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../models/user_model.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomTextField.dart';
import 'admin_loadingCheck.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isEmailError = false;
  bool isPasswordError = false;
  final FocusNode _passwordnode = FocusNode();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
//    _passwordnode=FocusNode(canRequestFocus: true);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30.h,
                            width: 30.w,
                            padding: EdgeInsets.all(5.h),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff5d5d5d)),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 20,
                            ),
                          )),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomText(
                        text: "Log In",
                        size: 30.sp,
                        color: const Color(0xfffcfcfc),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: "Log in with one of the following.",
                    color: const Color(0xff5d5d5d),
                    size: 16.sp,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      //google sign in button
                      Expanded(
                        child: CustomButton(
                            borderColor: const Color(0xff5d5d5d),
                            height: 50.h,
                            gradient: gradient,
                            onpress: () {},
                            child: Icon(
                              Icons.g_mobiledata,
                              size: 50.h,
                            )),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      //apple sign in button
                      Expanded(
                        child: CustomButton(
                            child: Icon(
                              Icons.apple,
                              size: 40.h,
                            ),
                            borderColor: const Color(0xff5d5d5d),
                            height: 50.h,
                            gradient: gradient,
                            onpress: () {}),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  CustomTextField(
                    isError: isEmailError,
                    hint: "example@gmail.com",
                    headerText: "Email*",
                    textEditingController: _email,
                    onEditComplete: () {
                      setState(() {
                        isEmailError = false;
                        FocusScope.of(context).requestFocus(_passwordnode);
                      });
                    },
                    onTap: () {
                      setState(() {
                        isEmailError = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    isError: isPasswordError,
                    hint: "************",
                    isPassword: true,
                    headerText: "Password*",
                    textEditingController: _password,
                    focusNode: _passwordnode,
                    onEditComplete: () {
                      setState(() {
                        isPasswordError = false;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    onTap: () {
                      setState(() {
                        isPasswordError = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: "Must be at least 8 characters",
                    color: const Color(0xff5d5d5d),
                    size: 16.sp,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                      onpress: () async {
                        String email = _email.text;
                        String password = _password.text;
                        Either<String, dynamic> user =
                            await auth.login(email, password);
                        if (user.isLeft) {
                          log(user.left);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(user.left),
                                );
                              });
                          if (user.left == "invalid-email") {
                            log("triggered");
                            isEmailError = true;
                          } else {
                            isPasswordError = true;
                          }
                        } else {
                          // todo:need to handle if it didn't return user on right but will leave it for now
                          log("entering get user");
                          Either<String, MyUser> res =
                              await Provider.of<FireStoreController>(context,
                                      listen: false)
                                  .getUser(user.right);
                          log("exiting get user");
                          if (res.isRight) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        AdminCheckPage(user: res.right)),
                                (route) => false);
                          } else {
                            log("entering here because get user didn't work as expected"); //todo : shouldn't return user.right here cuz that's mean we didn't get the user from firestore
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        AdminCheckPage(user: user.right)),
                                (route) => false);
                          }
                        }
                      },
                      gradient: gradient,
                      height: 50.h,
                      borderColor: const Color(0xff5d5d5d),
                      child: const CustomText(
                        text: "Log In",
                        align: Alignment.center,
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Don't have an account?",
                        color: Color(0xff5d5d5d),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          child: const CustomText(text: "Sign Up"))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
