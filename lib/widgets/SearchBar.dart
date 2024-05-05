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
      color: SearchBarColor,
      height: 45.h,
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9A9EA7),
            size: 32,
          ),
          hintText: "Search your chat",
          hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  height: 1.h,
                  color: Color(0xFF9A9EA7),
                  fontWeight: FontWeight.w400)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: SearchBarColor),
              borderRadius: BorderRadius.circular(32)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: SearchBarColor),
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
