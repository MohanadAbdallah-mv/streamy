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
  FirebaseAuth firebaseAuth;

  Auth({required this.firebaseAuth});

  Future<Either<String, UserCredential>> login(FormUser userForm);

  Future<Either<String, User>> register(FormUser userForm);
  Future<Either<String, String>> requestPassword(String email);
  Future<Either<String, String>> signOut(MyUser user);
}

class AuthImplement extends Auth {
  AuthImplement({required super.firebaseAuth});

  @override
  Future<Either<String, UserCredential>> login(FormUser userForm) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: userForm.email, password: userForm.password);
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      log(e.message.toString());
      return Left(e.code);
    }
  }

  @override
  Future<Either<String, User>> register(FormUser userForm) async {
    UserCredential credential;
    try {
      credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: userForm.email, password: userForm.password);

      print(credential);
    } on FirebaseAuthException catch (e) {
      log("auth_data error");
      return Left(e.code);
    }
    try {
      await firebaseAuth.currentUser!
          .updateDisplayName(userForm.name.toString());
      await firebaseAuth.currentUser!
          .reload(); //TODO user set display name not working at the moment
      User user = firebaseAuth.currentUser!;
      return Right(user);
    } on FirebaseException catch (e) {
      return Left(e.code);
    }
  }

  @override
  Future<Either<String, String>> requestPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return const Right("Success");
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
