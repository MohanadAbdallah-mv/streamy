import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_bottom_navigation_bar/global_bottom_navigation_bar.dart';
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
        primary: true,
        listOfChild: [
          HomePage(user: widget.user),
          //const Intro(),
          Profile(user: widget.user),
        ],
        listOfBottomNavigationItem: buildBottomNavigationItemList());
  }

  List<BottomNavigationItem> buildBottomNavigationItemList() => [
        BottomNavigationItem(
          activeIcon: const Icon(Icons.home),
          inActiveIcon: const Icon(Icons.home_outlined),
          title: 'Home',
          color: Colors.red,
          vSync: this,
        ),
        BottomNavigationItem(
          activeIcon: const Icon(Icons.person_pin),
          inActiveIcon: const Icon(Icons.person),
          title: 'Profile',
          color: Colors.white,
          vSync: this,
        ),
      ];
}
