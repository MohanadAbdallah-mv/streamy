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
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                        text: "Sign up",
                        size: 42,
                        color: titleColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomText(
                    text: "Sign up with one of the following.",
                    color: smallTextColor,
                    size: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                            borderColor: buttonBorderColor,
                            height: 60,
                            borderRadius: 16,
                            onpress: () {},
                            child: const Icon(
                              Icons.g_mobiledata,
                              size: 48,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: CustomElevatedButton(
                            borderColor: buttonBorderColor,
                            height: 60,
                            borderRadius: 16,
                            onpress: () {},
                            child: const Icon(
                              Icons.apple,
                              size: 32,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    hint: "Jhon doe",
                    headerText: "Name*",
                    thickness: 1,
                    borderFocusColor: focusColor,
                    textEditingController: _name,
                    onEditComplete: () {
                      FocusScope.of(context).requestFocus(_emailnode);
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    hint: "Enter your email",
                    headerText: "Email*",
                    textEditingController: _email,
                    thickness: 1,
                    focusNode: _emailnode,
                    onEditComplete: () {
                      FocusScope.of(context).requestFocus(_passwordnode);
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    hint: "Create a password",
                    isPassword: true,
                    headerText: "Password*",
                    thickness: 1,
                    textEditingController: _password,
                    focusNode: _passwordnode,
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
                  CustomElevatedButton(
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
                    gradient: gradientButton,
                    height: 45,
                    width: double.maxFinite,
                    borderColor: buttonBorderColor,
                    borderRadius: 10,
                    child: const CustomText(
                      text: "Sign up",
                      align: Alignment.center,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Already have an account?",
                        color: smallTextColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const CustomText(
                            text: "Log in",
                            size: 16,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 100,
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
