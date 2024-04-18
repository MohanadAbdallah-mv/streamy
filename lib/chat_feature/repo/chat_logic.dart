import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamy/chat_feature/data_source/chat_data.dart';
import '../../models/user_model.dart';
import '../../services/Cache_Helper.dart';
import '../model/Message.dart';

// I do the business logic here
// Represented in storing data locally when there is no internet connection
// I store data remotely when there is internet connection
// I need a interface to define my responsibilities
abstract class ChatHandler {
  bool isLoggedin;
  ChatImplement chatImplement;
  CacheData cacheData;

  ChatHandler(
      {required this.chatImplement,
      required this.cacheData,
      this.isLoggedin = false});

  Future<void> sendMessage(MyUser user, String receiverID, String message);

  Stream<QuerySnapshot<MyMessage>> getMessages(
      String SenderID, String reciverID);
}

class ChatHandlerImplement extends ChatHandler {
  ChatHandlerImplement(
      {required super.chatImplement, required super.cacheData});

  @override
  Future<void> sendMessage(
      MyUser user, String receiverID, String message) async {
    final Timestamp timeStamp = Timestamp.now();
    MyMessage newMessage = MyMessage(
        recieverID: receiverID,
        senderID: user.id,
        senderEmail: user.email,
        message: message,
        timeStamp: timeStamp);
    List<String> ids = [user.id, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    await chatImplement.sendMessage(chatRoomID, newMessage);
  }

  @override
  Stream<QuerySnapshot<MyMessage>> getMessages(
      String SenderID, String reciverID) {
    List<String> ids = [SenderID, reciverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    return chatImplement.getMessages(chatRoomID);
  }
//
// @override
// Future<Either<String, MyUser>> login(FormUser userForm) async {
//   try {
//     Either<String, UserCredential> potentialuser =
//         await authImplement.login(userForm);
//     if (potentialuser.isRight) {
//       MyUser user = MyUser(
//           id: potentialuser.right.user!.uid,
//           name: potentialuser.right.user!.displayName,
//           email: potentialuser.right.user!.email!,
//           role: "user",
//           phonenumber: potentialuser.right.user!.phoneNumber,
//           isLogged: true,
//           );
//       //Map<String,dynamic>json=user.toJson();
//       CacheData.setData(key: "user", value: jsonEncode(user.toJson()));
//
//       //CacheData.setData(key: "checker", value: "fuck....");
//
//       log("'we got user and saved in cashe' auth_repo ");
//       return Right(user);
//     } else {
//       log("'we don't have user' auth_repo");
//       return Left(potentialuser.left);
//     }
//   } catch (e) {
//     log("we fucked up -auth_repo");
//     return Left(e.toString());
//   }
// }
}

// i send
