
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:either_dart/either.dart';

import '../../services/Cache_Helper.dart';
import '../datasource/firestore_data.dart';
import '../models/user_model.dart';

abstract class Firestorehandler {
  FirestoreImplement firestoreImplement;
  CacheData cacheData;
  Firestorehandler({required this.firestoreImplement,required this.cacheData});

  Future<String> addUser(MyUser user);
  Future<Either<String,MyUser>> getUser(MyUser user);
  Future<String> updateUser(MyUser user);

}

class FirestorehandlerImplement extends Firestorehandler {
  FirestorehandlerImplement({required super.firestoreImplement,required super.cacheData});

  @override
  Future<String> addUser(MyUser user) async{
      try{
        String res=await firestoreImplement.addUser(user);
        return res;
      }catch (e){
        return e.toString();
      }
  }
  @override
  Future<Either<String,MyUser>> getUser(MyUser user) async{
    try{
      Either<String, MyUser> res=await firestoreImplement.getUser(user);
      if(res.isRight){
        CacheData.setData(key: "user", value: jsonEncode(user.toJson()));
       // CacheData.setData(key: "cart", value: jsonEncode(user.cart.toJson()));
        return Right(res.right);
      }else{return Left(res.left);}
    }catch (e){
      return Left(e.toString());
    }
  }
  @override
  Future<String> updateUser(MyUser user) async{
    try{
      String res=await firestoreImplement.updateUser(user);
     // log(res+"from logic");

      return res;
    }catch (e){
      log(e.toString()+"from logic error");
      return e.toString();
    }
  }
}