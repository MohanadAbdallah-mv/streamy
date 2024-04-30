// abstract class Auth{
//
//   register(){}
//   login(){}
// }
//
// class FireCall extends Auth{
//   @override
//   login(String email, String password) async {
//     // I Interact directly with the data layer
//     // Firebase - Local Storage
//     // I need a interface to define my responsibilities
//     return true;
//   }
// }
// class LocalCall extends Auth{
//
// }
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamy/models/user_model.dart';

import '../models/userform.dart';

abstract class Auth {
  FirebaseAuth firebaseauth;

  Auth({required this.firebaseauth});

  Future<Either<String, UserCredential>> login(FormUser userForm);

  Future<Either<String, User>> register(FormUser userForm);
  Future<Either<String, String>> requestPassword(String email);
  Future<Either<String, String>> signOut(MyUser user);
}

class AuthImplement extends Auth {
  AuthImplement({required super.firebaseauth});

  @override
  Future<Either<String, UserCredential>> login(FormUser userForm) async {
    try {
      final credential = await firebaseauth.signInWithEmailAndPassword(
          email: userForm.email, password: userForm.password);
      // log("'user is back again' auth_source");
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      //  log("'log in failure' auth_source");
      log(e.code);
      log(e.message.toString());
      return Left(e.code);
    }
  }

  @override
  Future<Either<String, User>> register(FormUser userForm) async {
    UserCredential credential;
    try {
      credential = await firebaseauth.createUserWithEmailAndPassword(
          email: userForm.email, password: userForm.password);
      //log("auth_data returned successfully");

      print(credential);

      //return Right(credential);
    } on FirebaseAuthException catch (e) {
      log("auth_data error");
      return Left(e.code);
    }
    //if user is returned from auth we will update his name and phone number
    try {
      //credential.user!.updatePhoneNumber(userForm.phonenumber!);

      // log(userForm.name.toString());
      await firebaseauth.currentUser!
          .updateDisplayName(userForm.name.toString());
      //log(firebaseauth.currentUser.toString());
      await firebaseauth.currentUser!
          .reload(); //TODO user set display name not working at the moment
      //log(credential.user.displayName.toString());
      User user = firebaseauth.currentUser!;
      // log("'user have name and phone number now' auth_source");
      return Right(user);
    } on FirebaseException catch (e) {
      return Left(e.code);
    }
  }

  @override
  Future<Either<String, String>> requestPassword(String email) async {
    try {
      // log(email);
      await firebaseauth.sendPasswordResetEmail(email: email.trim());
      //firebaseauth.sendPasswordResetEmail(email: email);
      return Right("Success");
    } on FirebaseAuthException catch (e) {
      log(e.code);
      log(e.message.toString());
      return Left(e.code);
    }
  }

  @override
  Future<Either<String, String>> signOut(MyUser user) async {
    try {
      FirebaseFirestore.instance
          .collection("UserToken")
          .doc(user.id)
          .set({"token": ""});
      return const Right("Success");
    } on FirebaseAuthException catch (e) {
      log(e.code);
      log(e.message.toString());
      return Left(e.code);
    }
  }
}
