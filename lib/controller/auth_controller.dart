import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../models/userform.dart';
import '../repo/auth_logic.dart';

class AuthController extends ChangeNotifier {

  final AuthHandlerImplement repo;

  AuthController({ required this.repo});

  Future<Either<String, dynamic>> login(String? email, String? password) async {
    try {
      FormUser userForm = FormUser(email: email!, password: password!);

      Either<String, dynamic> res = await repo.login(userForm);

      if (res.isRight) {
       // log("finally,logged in");
        notifyListeners();
        return Right(res.right);
      } else {
        notifyListeners();
        return Left(res.left);
      }
    } catch (e) {
      log(e.toString());
      log("failed at controller");
      notifyListeners();
      return Left(e.toString());
    }
  }

  Future<Either<String, dynamic>> register(String? name, String? phone, String? email, String? password) async {
    FormUser userForm = FormUser(
        name: name!, phonenumber: phone, email: email!, password: password!);
    //log(userForm.toString());
    Either<String, dynamic> res = await repo.register(userForm);
    //print(MyUser);
    if (res.isRight) {
      log("finally,registered");
      notifyListeners();

      return Right(res.right);
    } else {
      log(res.left.toString());

      log("failed at controller");
      notifyListeners();
      return Left(res.left);
    }
  }

  Future<String> resetPassword(String email) async {

    String response=await repo.requestPasswordReset(email).then((value) {
      if (value.isRight) {
        log(value.right);
        return value.right;
      } else {
        log(value.left);
        return value.left;
      }
    });
    return response;
  }

  String logout(user) {
    Either<String, String> res = repo.signout(user);
    if (res.isRight) {
      notifyListeners();
      return "done";
    } else {
      notifyListeners();
      return res.left;
    }
  }

  void isLogged(User? user) {}

  Either<String, MyUser> getCurrentUser() {
    Either<String, MyUser> user = repo.getCurrentUser();
    if (user.isRight) {
      return Right(user.right);
    } else {
      return Left(user.left);
    }
  }
}
