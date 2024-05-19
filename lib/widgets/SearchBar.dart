import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';

import '../constants.dart';

class SearchBarFor extends StatefulWidget {
  final Search search;
  const SearchBarFor({super.key,required this.search});

  @override
  State<SearchBarFor> createState() => _SearchBarForState();
}

class _SearchBarForState extends State<SearchBarFor> {
  @override
  Widget build(BuildContext context) {
    final chatProvider=Provider.of<ChatController>(context,listen: false);
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
            size: 32,
          ),
          hintText: widget.search==Search.addFriend?"Add Friends":"Search your chat",
          hintStyle: GoogleFonts.inter(
              textStyle: const TextStyle(
                  height: 1,
                  color: SearchBarTextFieldColor,
                  fontWeight: FontWeight.w400)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: searchBarColor),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: searchBarColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        cursorColor: Colors.grey,
        onChanged: (value) {
          //todo: implement seacrch algo for keyword entrance
          //chat provider add friend search
          //widget.search

        },
        onSubmitted: (searchText){
          chatProvider.searchFriend(Search.addFriend, searchText);
        },
      ),
    );
    ;
  }
}
