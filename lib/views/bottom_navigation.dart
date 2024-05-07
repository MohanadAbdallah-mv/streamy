import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_bottom_navigation_bar/global_bottom_navigation_bar.dart';
import 'package:streamy/constants.dart';
import 'package:streamy/views/Login.dart';
import 'package:streamy/views/profile.dart';
import '../models/user_model.dart';
import 'Signup.dart';
import 'home.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key, required this.user});

  final MyUser user;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ScaffoldGlobalBottomNavigation(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            padding: const EdgeInsets.only(top: 16),
            width: 54,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: focusColor,
              elevation: 0,
              onPressed: () {
                log("floating action button pressed");
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      width: 5,
                      color: Color(0xFF060F12),
                      strokeAlign: 1),
                  borderRadius: BorderRadius.circular(58)),
              child: const Icon(
                Icons.add,
                // size: 8.h,
                weight: 900,
              ),
              // child: Icon(Icons.add, size: 36.h),
            ),
          ),
          resizeToAvoidBottomInset: false,
          primary: true,
          listOfChild: [
            HomePage(user: widget.user),
            const Login(),
            const SizedBox(),
            const Signup(),
            Profile(user: widget.user),
          ],
          listOfBottomNavigationItem: buildBottomNavigationItemList()),
    );
  }

  List<BottomNavigationItem> buildBottomNavigationItemList() => [
        BottomNavigationItem(
          activeIcon: const Icon(Icons.home),
          inActiveIcon: const Icon(Icons.home_outlined),
          title: 'Chat',
          color: Colors.white,
          vSync: this,
        ),
        BottomNavigationItem(
          activeIcon: const Icon(Icons.local_phone),
          inActiveIcon: const Icon(Icons.local_phone_outlined),
          title: 'Call',
          color: Colors.white,
          vSync: this,
        ),
        BottomNavigationItem(
          activeIcon: const Icon(Icons.dew_point),
          inActiveIcon: const Icon(Icons.dew_point),
          title: '',
          color: Colors.white,
          vSync: this,
        ),
        BottomNavigationItem(
          activeIcon: const Icon(Icons.image),
          inActiveIcon: const Icon(Icons.image_outlined),
          title: 'Gallery',
          color: Colors.white,
          vSync: this,
        ),
        BottomNavigationItem(
          activeIcon: const Icon(Icons.person_pin),
          inActiveIcon: const Icon(Icons.person),
          title: 'Profile',
          color: Colors.white,
          vSync: this,
        )
      ];
}
