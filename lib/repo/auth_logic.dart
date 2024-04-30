import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/Cache_Helper.dart';
import '../datasource/auth_data.dart';
import '../models/user_model.dart';
import '../models/userform.dart';

abstract class AuthHandler {
  bool isLoggedIn;
  AuthImplement authImplement;
  CacheData cacheData;

  AuthHandler(
      {required this.authImplement,
      required this.cacheData,
      this.isLoggedIn = false});

  Future<Either<String, MyUser>> login(FormUser userForm);

  Future<Either<String, MyUser>> register(FormUser userForm);

  Future<Either<String, String>> signOut(MyUser user);

  Future<Either<String, String>> requestPasswordReset(String email);
}

class AuthHandlerImplement extends AuthHandler {
  AuthHandlerImplement(
      {required super.authImplement, required super.cacheData});

  @override
  Future<Either<String, MyUser>> login(FormUser userForm) async {
    try {
      Either<String, UserCredential> potentialUser =
          await authImplement.login(userForm);
      if (potentialUser.isRight) {
        MyUser user = MyUser(
          id: potentialUser.right.user!.uid,
          name: potentialUser.right.user!.displayName,
          email: potentialUser.right.user!.email!,
          role: "user",
          phonenumber: potentialUser.right.user!.phoneNumber,
          isLogged: true,
        );
        CacheData.setData(key: "user", value: jsonEncode(user.toJson()));

        log("'we got user and saved in cache' auth_repo ");
        return Right(user);
      } else {
        log("'we don't have user' auth_repo");
        return Left(potentialUser.left);
      }
    } catch (e) {
      log("we fucked up -auth_repo");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MyUser>> register(FormUser userForm) async {
    try {
      Either<String, User> potentialUser =
          await authImplement.register(userForm);
      if (potentialUser.isRight) {
        log("hi");
        MyUser user;
        log(potentialUser.right.displayName.toString());
        user = MyUser(
            id: potentialUser.right.uid,
            name: potentialUser.right.displayName,
            email: potentialUser.right.email!,
            phonenumber: potentialUser.right.phoneNumber,
            role: "user",
            isLogged: true);
        log("we got user");
        log(user.name.toString());
        log(user.id.toString());
        CacheData.setData(key: "user", value: jsonEncode(user.toJson()));
        return Right(user);
      } else {
        log("we don't have user");
        return Left(potentialUser.left);
      }
    } catch (e) {
      log(e.toString());
      return const Left("we fucked up");
    }
  }

  @override
  Future<Either<String, String>> signOut(MyUser user) async {
    try {
      CacheData.deleteItem(key: "user");
      return await authImplement.signOut(user).then(
          (value) => value.isRight ? const Right("done") : Left(value.left));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Either<String, MyUser> getCurrentUser() {
    try {
      Map<String, dynamic> cashedJsonUser =
          jsonDecode(CacheData.getData(key: "user"));
      MyUser user = MyUser.fromJson(cashedJsonUser);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> requestPasswordReset(String email) async {
    try {
      await authImplement.requestPassword(email);
      return const Right("Success");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
