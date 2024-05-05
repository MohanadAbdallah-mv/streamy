import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streamy/chat_feature/screens/chat_page.dart';
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
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Column(
            children: [
              //search bar
              SizedBox(
                height: 8.h,
              ),
              const SearchBarFor(),
              //stories list view
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: 90.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (builder, context) {
                      return StoryCircle();
                    }),
              ),
              Divider(
                indent: 24.w,
                endIndent: 24.w,
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
          maxRadius: 28,
        ),
        title: Text(data.email),
        subtitle: Text("last message bla ith max length then dots"),
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
