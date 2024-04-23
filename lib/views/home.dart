import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/screens/chat_page.dart';

import '../constants.dart';
import '../controller/firestore_controller.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  final MyUser user;

  HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
//var myfuture;
//   late Future<List<String>> categroyList;
//   late String category;
  //late int categoryindex;

//   Future<List<String>> MyFutureCategory() async {
//     var myfuture =
//         await Provider.of<FireStoreController>(context, listen: false)
//             .getCategory();
// //todo : implement either left and put it down to show error if it is left,null loading and right is data
//     return myfuture.right;
//   }
//
//   Future<List<Product>?> MyFutureBestSeller(String category) async {
//     log("entering myfuture best seller");
//     // String category=await Provider.of<FireStoreController>(context).categorySelected;
//     //log(category.toString());
//     log("entering best seller from view");
//     var myfuture =
//         await Provider.of<FireStoreController>(context, listen: false)
//             .getBestSeller(category);
//
// //todo : implement either left and put it down to show error if it is left,null loading and right is data
//
//     return myfuture.right;
//   }
//
//   Future<List<Product>> MyFutureDontMiss(String category) async {
//    // log('fuck');
//     var myfuture =
//         await Provider.of<FireStoreController>(context, listen: false)
//             .getDontMiss(category);
// //todo : implement either left and put it down to show error if it is left,null loading and right is data
//
//     return myfuture.right;
//   }

  @override
  void initState() {
    // categroyList = MyFutureCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(
            "Shoppie",
            style: GoogleFonts.sarina(
                textStyle: TextStyle(
                    color: AppTitleColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 34.sp)),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _builduserList(),
    );
  }

  Widget _builduserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _builduserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _builduserListItem(DocumentSnapshot doc) {
    MyUser data = MyUser.fromJson(doc.data() as Map<String, dynamic>);
    if (data.id != widget.user.id) {
      return ListTile(
        title: Text(data.email),
        onTap: () {
          List<String> ids = [widget.user.id, data.id];
          ids.sort();
          String chatRoomID = ids.join("_");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        user: widget.user,
                        receiverId: data.id,
                        receiverEmail: data.email,
                        chatRoomId: chatRoomID,
                      )));
        },
      );
    } else {
      return Container();
    }
    ;
  }
}
