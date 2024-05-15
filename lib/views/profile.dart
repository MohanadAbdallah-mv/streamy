import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamy/views/onBoarding.dart';
import 'package:toast/toast.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomText.dart';

class Profile extends StatefulWidget {
  MyUser user;

  Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var pickedImage;
  String? url;

  Future<void> getImageUrl() async {
    final imageRef =
        FirebaseStorage.instance.ref().child("images/${widget.user.id}.jpg");
    url = await imageRef.getDownloadURL();
    setState(() {});
    log(url.toString(), name: "url at init");
  }

  @override
  void initState() {
    //getImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image == null) return;
                            BotToast.showLoading();
                            final storageRef = FirebaseStorage.instance.ref();
                            final imageRef = storageRef
                                .child("images/${widget.user.id}.jpg");
                            final imageBytes = await image.readAsBytes();
                            await imageRef.putData(imageBytes);
                            final finalRef = await imageRef.getDownloadURL();
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.user.id)
                                .update({"Profile_Picture": finalRef});
                            await getImageUrl();
                            setState(() {
                              pickedImage = imageBytes;
                              url = finalRef;
                              log(url.toString(), name: "imageUrl");
                            });
                            BotToast.showText(
                                text: "Image Changed Successfully",
                                contentColor: Colors.green);

                            BotToast.closeAllLoading();
                          } catch (e) {
                            BotToast.closeAllLoading();
                            BotToast.showText(
                                text: "SomeThing went Wrong",
                                contentColor: Colors.red);
                            log(e.toString());
                          }
                        },
                        child: url != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    CachedNetworkImageProvider(url!))
                            : CircleAvatar(
                                radius: 64,
                                child: Container(),
                              ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      CustomButton(
                        height: 45,
                        gradient: gradientButton,
                        borderColor: buttonBorderColor,
                        borderRadius: 10,
                        onpress: () {
                          Provider.of<AuthController>(context, listen: false)
                              .logout(widget.user);
                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Intro()),
                            (route) => false,
                          );
                        },
                        width: 150,
                        child: const CustomText(
                          text: "Sign Out",
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          align: Alignment.center,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
