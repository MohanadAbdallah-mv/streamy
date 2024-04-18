import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:streamy/chat_feature/model/Message.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/models/user_model.dart';


class ChatController extends ChangeNotifier {

  final ChatHandlerImplement chatrepo;

  ChatController({ required this.chatrepo});
Future<void> sendMessage(MyUser user,String receiverID,String message)async{

chatrepo.sendMessage(user,receiverID,message);
}
  Stream<QuerySnapshot<MyMessage>> getMessages(MyUser user,String reciverID) {
    String SenderID=user.id;
    return chatrepo.getMessages(SenderID,reciverID);
  }
  // Future<Either<String, dynamic>> login(String? email, String? password) async {
  //   try {
  //     FormUser userForm = FormUser(email: email!, password: password!);
  //
  //     Either<String, dynamic> res = await repo.login(userForm);
  //
  //     if (res.isRight) {
  //      // log("finally,logged in");
  //       notifyListeners();
  //       return Right(res.right);
  //     } else {
  //       notifyListeners();
  //       return Left(res.left);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     log("failed at controller");
  //     notifyListeners();
  //     return Left(e.toString());
  //   }
  // }

}
