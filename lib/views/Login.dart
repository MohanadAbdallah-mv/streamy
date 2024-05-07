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
          backgroundColor: primaryColor,
          body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                            height: 48,
                            width: 48,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: buttonBorderColor),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              size: 24,
                            ),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      const CustomText(
                        text: "Login",
                        size: 42,
                        color: titleColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const CustomText(
                    text: "Log in with one of the following.",
                    color: smallTextColor,
                    size: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      //google sign in button
                      Expanded(
                        child: CustomButton(
                            borderColor: buttonBorderColor,
                            height: 60,
                            borderRadius: 16,
                            onpress: () {},
                            child: const Icon(
                              Icons.g_mobiledata,
                              size: 48,
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //apple sign in button
                      Expanded(
                        child: CustomButton(
                            borderColor: buttonBorderColor,
                            height: 60,
                            borderRadius: 16,
                            onpress: () {},
                            child: const Icon(
                              Icons.apple,
                              size: 32,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    isError: isEmailError,
                    hint: "example@gmail.com",
                    headerText: "Email*",
                    borderFocusColor: focusColor,
                    thickness: 1,
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
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    isError: isPasswordError,
                    hint: "************",
                    isPassword: true,
                    headerText: "Password*",
                    borderFocusColor: focusColor,
                    thickness: 1,
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
                  const SizedBox(
                    height: 8,
                  ),
                  const CustomText(
                    text: "Must be at least 8 characters",
                    color: smallTextColor,
                    size: 16,
                  ),
                  const SizedBox(
                    height: 32,
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
                      height: 45,
                      gradient: gradientButton,
                      borderColor: buttonBorderColor,
                      borderRadius: 10,
                      child: const CustomText(
                        text: "Login",
                        align: Alignment.center,
                        size: 16,
                      )),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Don't have an account?",
                        color: smallTextColor,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          child: const CustomText(
                            text: "Sign Up",
                            size: 16,
                          ))
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
