import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repo/firestore_logic.dart';

class FireStoreController extends ChangeNotifier {
  FirestorehandlerImplement firestorehandlerImplement;

  FireStoreController({
    required this.firestorehandlerImplement,
  });

  Future<String> addUser(MyUser user) async {
    try {
      String res = await firestorehandlerImplement.addUser(user);

      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Either<String, MyUser>> getUser(MyUser user) async {
    try {
      Either<String, MyUser> res =
          await firestorehandlerImplement.getUser(user);
      user = res.right;
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Future<void> updateUser(MyUser user) async {
  //   String res = await firestorehandlerImplement.updateUser(user);
  //   print(res);
  // }

  Future<String> getAdminToken() async {
    String token = "";
    await FirebaseFirestore.instance
        .collection("UserToken")
        .doc("admin")
        .get()
        .then((value) => token = value.data()!["token"]);
    print(token);
    return token;
  }
}
