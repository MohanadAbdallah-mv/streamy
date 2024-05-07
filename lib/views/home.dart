import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streamy/chat_feature/screens/chat_page.dart';
import 'package:streamy/widgets/CustomText.dart';
import 'package:streamy/widgets/SearchBar.dart';
import 'package:streamy/widgets/Story.dart';
import '../constants.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  final MyUser user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //search bar
              SizedBox(
                height: 12,
              ),
              const SearchBarFor(),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 16),
                child: Text(
                  "RECENTS UPDATES",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 12,
              ),

              //stories list view
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (builder, index) {
                      if (index == 0) {
                        return StoryCircle(
                          myStatus: true,
                        );
                      }
                      return StoryCircle();
                    }),
              ),
              // SizedBox(
              //   height: 8.h,
              // ),
              const Divider(
                indent: 24,
                endIndent: 24,
              ),
              //chats
              Expanded(
                flex: 10,
                child: _builduserList(),
              ),
            ],
          ),
        ),
      ),
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
            return const CircularProgressIndicator();
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
        leading: const CircleAvatar(
          maxRadius: 24,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: data.email),
            const CustomText(
              text: "4:25PM",
              size: 10,
              fontWeight: FontWeight.w100,
              color: SearchBarTextFieldColor,
            )
          ],
        ),
        subtitle: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              size: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: CustomText(
                text: "last message bla ith max length then dots",
                trim: true,
                size: 10,
              ),
            ),
          ],
        ),
        onTap: () {
          List<String> ids = [widget.user.id, data.id];
          ids.sort();
          String chatRoomID = ids.join("_");
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
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
