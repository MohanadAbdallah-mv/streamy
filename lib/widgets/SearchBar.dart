import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class SearchBarFor extends StatefulWidget {
  const SearchBarFor({super.key});

  @override
  State<SearchBarFor> createState() => _SearchBarForState();
}

class _SearchBarForState extends State<SearchBarFor> {
  @override
  Widget build(BuildContext context) {
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
          hintText: "Search your chat",
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
        },
      ),
    );
    ;
  }
}
