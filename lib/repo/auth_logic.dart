import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/Cache_Helper.dart';
import '../datasource/auth_data.dart';
import '../models/user_model.dart';
import '../models/userform.dart';

// I do the business logic here
// Represented in storing data locally when there is no internet connection
// I store data remotely when there is internet connection
// I need a interface to define my responsibilities
abstract class AuthHandler {
  bool isLoggedin;
  AuthImplement authImplement;
  CacheData cacheData;

  AuthHandler(
      {required this.authImplement,
      required this.cacheData,
      this.isLoggedin = false});

  Future<Either<String, MyUser>> login(FormUser userForm);

  Future<Either<String, MyUser>> register(FormUser userForm);

  Either<String, String> signout(MyUser user);

  Future<Either<String, String>> requestPasswordReset(String email);
}

class AuthHandlerImplement extends AuthHandler {
  AuthHandlerImplement(
      {required super.authImplement, required super.cacheData});

  @override
  Future<Either<String, MyUser>> login(FormUser userForm) async {
    try {
      Either<String, UserCredential> potentialuser =
          await authImplement.login(userForm);
      if (potentialuser.isRight) {
        MyUser user = MyUser(
            id: potentialuser.right.user!.uid,
            name: potentialuser.right.user!.displayName,
            email: potentialuser.right.user!.email!,
            role: "user",
            phonenumber: potentialuser.right.user!.phoneNumber,
            isLogged: true,
            );
        //Map<String,dynamic>json=user.toJson();
        CacheData.setData(key: "user", value: jsonEncode(user.toJson()));

        //CacheData.setData(key: "checker", value: "fuck....");

        log("'we got user and saved in cashe' auth_repo ");
        return Right(user);
      } else {
        log("'we don't have user' auth_repo");
        return Left(potentialuser.left);
      }
    } catch (e) {
      log("we fucked up -auth_repo");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MyUser>> register(FormUser userForm) async {
    try {
      Either<String, User> potentialuser =
          await authImplement.register(userForm);
      if (potentialuser.isRight) {
        log("hi");
        MyUser user;
        log(potentialuser.right.displayName.toString());
        user = MyUser(
            id: potentialuser.right.uid,
            name: potentialuser.right.displayName,
            email: potentialuser.right.email!,
            phonenumber: potentialuser.right.phoneNumber,
            role: "user",
            isLogged: true
            );
        log("we got user");
        log(user.name.toString());
        log(user.id.toString());
        CacheData.setData(key: "user", value: jsonEncode(user.toJson()));
        return Right(user);
      } else {
        log("we don't have user");
        return Left(potentialuser.left);
      }
    } catch (e) {
      log(e.toString());
      return Left("we fucked up");
    }
  }

  @override
  Either<String, String> signout(MyUser user) {
    try {
      CacheData.deleteItem(key: "user");
      return Right("done");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Either<String, MyUser> getCurrentUser() {
    try {
      Map<String, dynamic> cashedjsonuser =
          jsonDecode(CacheData.getData(key: "user"));
      MyUser user = MyUser.fromJson(cashedjsonuser);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> requestPasswordReset(String email) async {
    try {
      await authImplement.requestpassword(email);
      return Right("Success");
    } catch (e) {
      return Left(e.toString());
    }
  }
}

// i send
