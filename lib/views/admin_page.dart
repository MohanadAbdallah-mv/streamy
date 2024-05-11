import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/user_model.dart';

class AdminPage extends StatefulWidget {
  MyUser user;

  AdminPage({super.key, required this.user});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Shoppie",
            style: GoogleFonts.sarina(
                textStyle: TextStyle(
                    color: AppTitleColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 34)),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: 600,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 50),
              //   child: CustomButton(
              //     child: CustomText(
              //       text: "Orders",
              //       color: primaryColor,
              //       fontWeight: FontWeight.w700,
              //       align: Alignment.center,
              //       size: 20,
              //     ),
              //     color: Colors.white,
              //     borderColor: primaryColor,
              //     onpress: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //                   OrdersPage(adminUser: widget.user)));
              //     },
              //     width: 150,
              //   ),
              // ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
