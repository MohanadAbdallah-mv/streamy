import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../chat_feature/controller/chat_controller.dart';
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
    final chatProvider=Provider.of<ChatController>(context,listen: false);
    return Padding(
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
          // Expanded(
          //   flex: 10,
          //   child: _buildSuggestedFriendsList(),
          // ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 60,
              child: ListView.builder(
                itemCount: chatProvider.usersList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, int index) {
                  return Container(color: Colors.black,);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
