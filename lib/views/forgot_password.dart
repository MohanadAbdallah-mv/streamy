import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomTextField.dart';

class Forgot_Password extends StatefulWidget {
  const Forgot_Password({super.key});

  @override
  State<Forgot_Password> createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, auth, child) {
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text("Forgot password ",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppTitleColor,
                      fontFamily: "ReadexPro",
                      fontWeight: FontWeight.w600,
                    )),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 50),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Svg pic
                        Container(
                          padding: EdgeInsets.only(left: 28, top: 20),
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            "assets/svg/forgot_password_guy.svg",
                            fit: BoxFit.values.last,
                          ),
                        ),
                        //Email Text Field

                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 60),
                          child: CustomTextField(
//                          isError: isEmailError,
                            headerText: "",
                            customheader: CustomText(
                              text: "Please enter your email adress",
                              align: Alignment.bottomLeft,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontfamily: "ReadexPro",
                              size: 16,
                            ),
                            hint: "Malikvis@gmail.com",
                            textEditingController: _email,
                            onEditComplete: () {
                              setState(() {
                                //                            isEmailError = false;
                                //                             FocusScope.of(context).requestFocus(
                                //                                 _passwordnode);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CustomText(
                            text:
                            "we will send verification code if you did not recieve any, please click ",
                            color: Colors.black,
                            textalign: TextAlign.left,
                            fontfamily: "ReadexPro",
                            fontWeight: FontWeight.w400,
                            size: 15,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  //todo: add forget password with it functions/edit error for password field
                  padding: const EdgeInsets.only(top: 220, left: 16, right: 16),
                  child: CustomButton(
                    width: double.maxFinite,
                    child: CustomText(
                      text: "Next",
                      color: Colors.white,
                      align: Alignment.center,
                      size: 15,
                    ),
                    onpress: () async {
                      String email = _email.text;
                      String response = await auth.resetPassword(email);
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text(response),);
                      });
                      print(response);
                      //Navigator.push(context,MaterialPageRoute(builder: (context)=>OTP_screen(email:email,)));
                      // Either<String, dynamic> user =
                      // await auth.login(email, password);
                      // if (user.isLeft) {
                      //   log(user.left);
                      //
                      //   if (user.left == "invalid-email") {
                      //     log("triggered");
                      //     isEmailError = true;
                      //   }
                      // }
                    },
                    borderColor: Colors.white,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ));
    });
  }
}
