import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../models/user_model.dart';

abstract class Firestore {
  FirebaseFirestore firebaseFirestore;

  Firestore({required this.firebaseFirestore});

  Future<Either<String, MyUser>> getUser(MyUser user);

  Future<String> updateUser(MyUser user);

  Future<String> addUser(MyUser user);
}

class FirestoreImplement extends Firestore {
  FirestoreImplement({required super.firebaseFirestore});

  @override
  Future<String> addUser(MyUser user) async {
    try {
      CollectionReference<Map<String, dynamic>> usersref =
          firebaseFirestore.collection('users');
      await usersref.doc(user.id).set({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "phonenumber": user.phonenumber,
        "isLogged": user.isLogged,
        "role": user.role
      }); //.add(user.toJson());
      return "success";
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  @override
  Future<Either<String, MyUser>> getUser(MyUser user) async {
    try {
      log("entering getuser at firestore data");
      final usersRef = firebaseFirestore
          .collection('users')
          .withConverter<MyUser>(
              fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
              toFirestore: (myuser, _) => myuser.toJson());
      log("${user.id}");
      //log("${usersRef.doc(user.id).get().}");
      MyUser userUpdates = await usersRef
          .doc(user.id)
          .get()
          .then((value) => value.data()!)
          .catchError((error) => log("failed to get user${error}"));
      //log("user updates is back from data source at getuser  ${userUpdates.name} +${userUpdates.role}+${userUpdates.cart.items} +${userUpdates.cart.totalPrice} + ${userUpdates.wishList}}");
      return Right(userUpdates);
    } on FirebaseException catch (e) {
      log("error  getuser at firestore data ${e.message}");
      return Left(e.message.toString());
    }
  }

  @override
  Future<String> updateUser(MyUser user) async {
    try {
      log("entering");
      final usersref = firebaseFirestore
          .collection('users')
          .withConverter<MyUser>(
              fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
              toFirestore: (myuser, _) => myuser.toJson());
      //final docref=firebaseFirestore.doc(documentPath).
      log("entering");
      await usersref.doc(user.id).update(user.toJson());
      log("user updates is done");
      return "updated";
    } on FirebaseException catch (e) {
      log(e.message.toString() + "firestore data");
      return e.message.toString();
    }
  }
}
