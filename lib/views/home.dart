import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streamy/chat_feature/screens/chat_page.dart';
import 'package:streamy/widgets/CustomText.dart';
import 'package:streamy/widgets/SearchBar.dart';
import 'package:streamy/widgets/Story.dart';
import '../chat_feature/controller/chat_controller.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String? changes;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // <--
    super.initState();
  }

//todo check the output of this
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isBg = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;
    final isScreen = state == AppLifecycleState.resumed;

    isBg || isScreen == true || isClosed == false
        ? setState(() {
            changes = "User is online";
          })
        : setState(() {
            changes = "User is offline";
          });
    log(changes.toString(), name: "user status");
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
              const SizedBox(
                height: 12,
              ),
              const SearchBarFor(
                search: Search.myFriends,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 16),
                child: Text(
                  "RECENTS UPDATES",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
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

              const Divider(
                indent: 24,
                endIndent: 24,
              ),
              //chats
              Expanded(
                flex: 10,
                child: _buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    log(widget.user.id);

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .where("users", arrayContains: widget.user.id)
            .where("users", isNull: false)
            .orderBy("last_time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            //return const CircularProgressIndicator();
            return const LoadingSkeleton();
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            );
          }
          return const LoadingSkeleton();
        });
  }

  Widget _buildUserListItem(DocumentSnapshot doc) {
    log(doc.data().toString());
    //MyUser data = MyUser.fromJson(doc.data() as Map<String, dynamic>);
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    log(widget.user.profilePicture.toString());
    final otherUserID =
        data["users"].firstWhere((id) => id != widget.user.id); //other user id
    Map<String, dynamic> otherUserData;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(otherUserID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {}
          if (snapshot.hasData) {
            otherUserData = snapshot.data!.data()!;
            log(otherUserData["Profile_Picture"].toString(), name: "image");
            return ListTile(
              leading: CircleAvatar(
                maxRadius: 24,
                backgroundImage: otherUserData["Profile_Picture"] != null
                    ? CachedNetworkImageProvider(
                        otherUserData["Profile_Picture"],
                      )
                    : null,
                child: otherUserData["Profile_Picture"] != null
                    ? null
                    : Text((otherUserData["name"] as String)
                        .characters
                        .first
                        .toUpperCase()),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: otherUserData["name"]),
                  Column(
                    children: [
                      CustomText(
                        text: DateFormat('hh:mm-aa')
                            .format((data["last_time"] as Timestamp).toDate())
                            .toString(),
                        size: 10,
                        fontWeight: FontWeight.w100,
                        color: SearchBarTextFieldColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      data["to_user_id"] == widget.user.id &&
                              data[widget.user.id] > 0
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.green,
                              child: Text(
                                data[widget.user.id].toString(),
                                style: const TextStyle(fontSize: 8),
                              ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  data["from_user_id"] == widget.user.id
                      ? Icon(
                          data[data["to_user_id"]] > 0
                              ? Icons.check_circle_outline
                              : Icons.check_circle,
                          size: 16,
                        )
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: CustomText(
                        text: data["last_msg"].toString(),
                        overflow: TextOverflow.ellipsis,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                List<String> ids = [widget.user.id, otherUserData["id"]];
                ids.sort();
                String chatRoomID = ids.join("_");
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => ChatPage(
                      user: widget.user,
                      receiverId: otherUserData["id"],
                      receiverEmail: otherUserData["email"],
                      receiverName: otherUserData["name"],
                      chatRoomId: chatRoomID,
                    ),
                  ),
                );
              },
            );
          }
          return const LoadingSkeleton();
          ;
        });
  }
}

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey,
      child: ListTile(
        leading: CircleAvatar(
          maxRadius: 24,
          backgroundColor: Colors.black.withOpacity(0.04),
          child: const Skeleton(
            height: 1,
            width: 1,
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Skeleton(
              height: 10,
              width: 54,
            ),
            Column(
              children: [
                Skeleton(
                  height: 10,
                  width: 32,
                ),
              ],
            )
          ],
        ),
        subtitle: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: Skeleton(
                width: 128,
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    this.height,
    this.width,
    super.key,
  });
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}
