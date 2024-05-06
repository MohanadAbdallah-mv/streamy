import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomTextField.dart';
import 'Login.dart';
import 'admin_loadingCheck.dart';
import 'bottom_navigation.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;
  late final TextEditingController _phonenumber;
  late final TextEditingController _phone;
  final FocusNode _phonenumbernode = FocusNode();
  final FocusNode _emailnode = FocusNode();
  final FocusNode _passwordnode = FocusNode();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _phonenumber = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _phonenumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Consumer<AuthController>(
          builder: (context, auth, child) {
            return SingleChildScrollView(
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
                              size: 20.h,
                            ),
                          )),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomText(
                        text: "Sign up",
                        size: 30.sp,
                        color: const Color(0xfffcfcfc),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: "Sign up with one of the following.",
                    color: const Color(0xfffcfcfc),
                    size: 16.sp,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                            borderColor: const Color(0xff5d5d5d),
                            height: 60.h,
                            onpress: () {},
                            gradient: gradient,
                            child: Icon(
                              Icons.g_mobiledata,
                              size: 60.h,
                            )),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                        child: CustomButton(
                            borderColor: const Color(0xff5d5d5d),
                            height: 60.h,
                            onpress: () {},
                            gradient: gradient,
                            child: Icon(
                              Icons.apple,
                              size: 40.h,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    hint: "Jhon doe",
                    headerText: "Name*",
                    textEditingController: _name,
                    onEditComplete: () {
                      FocusScope.of(context).requestFocus(_emailnode);
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    hint: "Enter your email",
                    headerText: "Email*",
                    textEditingController: _email,
                    focusNode: _emailnode,
                    onEditComplete: () {
                      FocusScope.of(context).requestFocus(_passwordnode);
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    hint: "Create a password",
                    isPassword: true,
                    headerText: "Password*",
                    textEditingController: _password,
                    focusNode: _passwordnode,
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
                      String name = _name.text;
                      Either<String, dynamic> user =
                          await auth.register(name, "", email, password);
                      if (user.isLeft) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(user.left),
                              );
                            });
                      } else {
                        await Provider.of<FireStoreController>(context,
                                listen: false)
                            .addUser(user.right)
                            .then((value) {
                          if (value == "success") {
                            print("entering");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        AdminCheckPage(user: user.right)),
                                (route) => false);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(value),
                                  );
                                });
                          } //todo check this one again with error and try catches
                        });
                      }
                    },
                    gradient: gradient,
                    height: 48,
                    borderColor: const Color(0xff5d5d5d),
                    child: const CustomText(
                      text: "Sign up",
                      align: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Already have an account?",
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
                                    builder: (context) => const Login()));
                          },
                          child: const CustomText(text: "Log in"))
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
