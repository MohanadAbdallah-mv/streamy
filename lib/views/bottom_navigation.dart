import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_bottom_navigation_bar/global_bottom_navigation_bar.dart';
import 'package:streamy/constants.dart';
import 'package:streamy/views/profile.dart';

import '../models/user_model.dart';
import 'home.dart';
import 'onBoarding.dart';

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
    return ScaffoldGlobalBottomNavigation(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
            padding: EdgeInsets.only(top: 8.h),
            width: 62.w,
            height: 62.h,
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 5.w, color: const Color(0xFF060F12)),
                  borderRadius: BorderRadius.circular(58.r)),
              child: Icon(Icons.add,size: 32.h),
            )),
        primary: true,
        listOfChild: [
          HomePage(user: widget.user),
          const Intro(),
          const Intro(),
          Profile(user: widget.user),
        ],
        listOfBottomNavigationItem: buildBottomNavigationItemList());
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
