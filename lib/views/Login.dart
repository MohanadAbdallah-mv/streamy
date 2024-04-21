import 'dart:developer';


import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
            appBar: AppBar(automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  "Shoppie",
                  style: GoogleFonts.sarina(
                      textStyle: TextStyle(
                          color: AppTitleColor, fontWeight: FontWeight.w400,fontSize: 34.sp)),
                ),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 40.w),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Svg pic
                          Container(
                            decoration: BoxDecoration(),
                            child: SvgPicture.asset(
                              "assets/svg/st_l_app.svg",
                              fit: BoxFit.values.last,
                            ),
                          ),
                          //Email Text Field
                          Padding(
                            padding: EdgeInsets.only(top: 45.h),
                            child: CustomTextField(
                              isError: isEmailError,
                              headerText: "Email",
                              hint: "Malikvis@gmail.com",
                              textEditingController: _email,
                              onEditComplete: () {
                                setState(() {
                                  isEmailError = false;
                                  FocusScope.of(context).requestFocus(
                                      _passwordnode);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          //Password Text Field
                          CustomTextField(
                            isError: isPasswordError,
                            headerText: "Password",
                            hint: "************",
                            isPassword: true,
                            textEditingController: _password,
                            focusNode: _passwordnode,
                            onEditComplete: () {
                              setState(() {
                                isPasswordError = false;
                                FocusScope.of(context).unfocus();
                              });
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                        ]),
                  ), Padding(padding: EdgeInsets.only(top: 52.h),
                    child: GestureDetector(onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Forgot_Password()));
                    },
                      child: CustomText(text: "forgot password?",
                          underline: true,
                          color: ErrorMesseageText,
                          align: Alignment.center),
                    ),),
                  Padding( //todo: add forget password with it functions/edit error for password field
                    padding: EdgeInsets.only(
                        top: 24.h, left: 13.w, right: 13.w),
                    child: CustomButton(
                      width: double.maxFinite,
                      child: CustomText(
                        text: "Log in",
                        color: Colors.white,
                        align: Alignment.center,
                        size: 15,
                      ),
                      onpress: () async {
                        String email = _email.text;
                        String password = _password.text;
                        Either<String, dynamic> user =
                        await auth.login(email, password);
                        if (user.isLeft) {
                          log(user.left);
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(content: Text(user.left),);
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
                          Either<String,MyUser>res=await Provider.of<FireStoreController>(context,listen: false).getUser(user.right);
                          log("exiting get user");
                          if(res.isRight){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        AdminCheckPage(user: res.right)),(route) =>false);
                          }else{
                            log("entering here because get user didn't work as expected");//todo : shouldn't return user.right here cuz that's mean we didn't get the user from firestore
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        AdminCheckPage(user: user.right)),(route) =>false);
                          }

                        }
                      },
                      borderColor: Colors.white,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
