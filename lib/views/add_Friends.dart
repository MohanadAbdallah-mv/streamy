import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../chat_feature/controller/chat_controller.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../widgets/SearchBar.dart';

class AddFriendPage extends StatefulWidget {
  final MyUser user;

  const AddFriendPage({super.key, required this.user});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 18, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //search bar
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  const Expanded(
                    child: SearchBarFor(search: Search.addFriend,),
                  ),
                ],
              ),
              const Divider(
                indent: 24,
                endIndent: 24,
              ),
              //chats
              Expanded(
                flex: 10,
                child: _buildSuggestedFriendsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSuggestedFriendsList() {
  return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitThreeBounce(
                color: focusColor,
                size: 50,
              ));
        }
        if (snapshot.hasData) {
          return Container();
        }
        return Container();
      });
}
