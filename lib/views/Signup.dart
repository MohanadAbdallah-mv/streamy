
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
    _phonenumber=TextEditingController();

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
        body: Consumer<AuthController>(builder: (context, auth, child) {
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(left: 16.w, right: 40.w),
              child: Column(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            "assets/svg/st_l_app.svg",
                            fit: BoxFit.values.last,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: CustomTextField(
                            headerText: "Name",
                            hint: "Malik",
                            textEditingController: _name,
                            onEditComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(_phonenumbernode);
                            },
                          ),
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        //
            CustomTextField(
                          headerText: "Phone Number",
                          hint: "+0256526524845",
                          focusNode: _phonenumbernode,
                          onEditComplete: () {
                            FocusScope.of(context).requestFocus(_emailnode);
                          },
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        CustomTextField(
                          headerText: "Email",
                          hint: "Malikvis@gmail.com",
                          textEditingController: _email,
                          focusNode: _emailnode,
                          onEditComplete: () {
                            FocusScope.of(context).requestFocus(_passwordnode);
                          },
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        CustomTextField(
                          headerText: "Password",
                          hint: "************",
                          isPassword: true,
                          textEditingController: _password,
                          focusNode: _passwordnode,
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // )
                      ]),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: CustomButton(
                      child: CustomText(
                        text: "Sign up",
                        color: Colors.white,
                        align: Alignment.center,
                        size: 15,
                      ),
                      onpress: () async {
                        String email = _email.text;
                        String password = _password.text;
                        String name = _name.text;
                        String phone =_phonenumber.text;
                        Either<String, dynamic> user =
                            await auth.register(name, phone, email, password);
                        if (user.isLeft) {

                          showDialog(context: context, builder: (context) {
                            return AlertDialog(content: Text(user.left),);
                          });
                        } else {

                          await Provider.of<FireStoreController>(context,listen: false).addUser(user.right).then((value) {
                            if (value=="success"){
                              print("entering");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (context) =>
                                          AdminCheckPage(user: user.right)),(route) =>false);
                            }else{
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(content: Text(value),);
                              });
                            }//todo check this one again with error and try catches
                          });

                        }
                      },
                      borderColor: Colors.white,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
