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
      height: 45.h,
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      decoration: BoxDecoration(
          color: searchBarColor,
          borderRadius: BorderRadius.all(Radius.circular(12.r))),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: SearchBarTextFieldColor,
            size: 32,
          ),
          hintText: "Search your chat",
          hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  height: 1.h,
                  color: SearchBarTextFieldColor,
                  fontWeight: FontWeight.w400)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: searchBarColor),
              borderRadius: BorderRadius.circular(32)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: searchBarColor),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        cursorColor: const Color(0xff130F26),
        onChanged: (value) {
          //todo: implement seacrch algo for keyword entrance
        },
      ),
    );
    ;
  }
}
