import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_bottom_navigation_bar/global_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:streamy/views/profile.dart';

import '../controller/firestore_controller.dart';
import '../models/user_model.dart';
import 'home.dart';
import 'onBoarding.dart';


class MainHome extends StatefulWidget {
  MainHome({super.key, required this.user});

  MyUser user;
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  @override
  int index = 2;
// Future<void>prepareUser()async{
//   Provider.of<FireStoreController>(context,listen: false).cartItems=widget.user.cart.items!;
//   Provider.of<FireStoreController>(context,listen: false).likedListIds=widget.user.wishList;
//   await Provider.of<FireStoreController>(context,listen: false).updateWishList();
//   log("bottom navigation bar likedlistids${Provider.of<FireStoreController>(context,listen: false).likedListIds}");
//   log("bottom navigation bar likedlistids${widget.user.wishList}");
// }
  @override
  void initState() {

  //log("should print cart items here \\\\\\\\\\${Provider.of<FireStoreController>(context,listen: false).cartItems.toString()}");
    // TODO: implement initState
  //prepareUser();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return ScaffoldGlobalBottomNavigation(primary: true,listOfChild: [
      Profile(user: widget.user),
      Intro(),
      HomePage(user: widget.user),
    ], listOfBottomNavigationItem: buildBottomNavigationItemList());
  }
  List<BottomNavigationItem> buildBottomNavigationItemList() => [
    BottomNavigationItem(
      activeIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/User.svg"),
      inActiveIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/User.svg"),
      title: 'Profile',
      color: Colors.white,
      vSync: this,
    ),BottomNavigationItem(
      activeIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/Category.svg"),
      inActiveIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/Category.svg"),
      title: 'Category',
      color: Colors.white,
      vSync: this,
    ),BottomNavigationItem(
      activeIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/Home.svg"),
      inActiveIcon: SvgPicture.asset("assets/svg/bottom_navigation_bar/Home.svg"),
      title: 'Home',
      color: Colors.white,
      vSync: this,
    ),
  ];

}
