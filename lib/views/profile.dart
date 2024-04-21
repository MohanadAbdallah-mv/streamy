import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';
class Profile extends StatefulWidget {
  MyUser user;
  Profile({super.key,required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
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
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CustomButton(
                    child:CustomText(text: "Sign Out",color: primaryColor,fontWeight: FontWeight.w700,align: Alignment.center,
                      size: 20,),
                    color: Colors.white,borderColor: primaryColor,
                    onpress: (){
                      Provider.of<AuthController>(context, listen: false)
                          .logout(widget.user);
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => new MyApp()),
                            (route) => false,);
                    },width: 150,
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 12),
                //   child: FutureBuilder(
                //       future:products ,
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData ) {
                //           return ListView.builder(
                //               shrinkWrap: true,
                //               itemCount: snapshot.data!.length,
                //               scrollDirection: Axis.vertical,
                //               itemBuilder: (context, index) =>
                //                   ProductCardHorizontal(
                //                       index: index,
                //                       product: snapshot.data![index],
                //                       user: widget.user));
                //         } else {
                //
                //           return CircularProgressIndicator();
                //         }
                //       }),
                // ),

              ],
            ),
          ),
        ));
  }
}
