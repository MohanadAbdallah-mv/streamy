import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/data_source/chat_data.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/repo/auth_logic.dart';
import 'package:streamy/repo/firestore_logic.dart';
import 'package:streamy/services/Cache_Helper.dart';
import 'package:streamy/services/NotificationHandler/notification_handler.dart';
import 'package:streamy/views/admin_loadingCheck.dart';
import 'package:streamy/views/onBoarding.dart';

import 'controller/auth_controller.dart';
import 'controller/firestore_controller.dart';
import 'datasource/auth_data.dart';
import 'datasource/firestore_data.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheData.cacheInitialization();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationHandler.instance.init().then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => FireStoreController(
              firestorehandlerImplement: FirestorehandlerImplement(
                  cacheData: CacheData(),
                  firestoreImplement: FirestoreImplement(
                      firebaseFirestore: FirebaseFirestore.instance)))),
      ChangeNotifierProvider(
          create: (context) => AuthController(
              repo: AuthHandlerImplement(
                  authImplement:
                      AuthImplement(firebaseauth: FirebaseAuth.instance),
                  cacheData: CacheData()))),
      ChangeNotifierProvider(
          create: (context) => ChatController(
              chatrepo: ChatHandlerImplement(
                  chatImplement:
                      ChatImplement(firebaseFirestore: FirebaseFirestore.instance),
                  cacheData: CacheData()))),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //MyUser? user=Provider.of<AuthController>(context).getCurrentUser();
    //print(user);
    Either<String, MyUser> user =
        Provider.of<AuthController>(context).getCurrentUser();
    // user.isRight
    //     ? Provider.of<FireStoreController>(context, listen: false)
    //         .updateItemsList(user.right)
    //     : null;
    //print("//////////////////////////////////////////////////"+user.right.role);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: user.isRight ? AdminCheckPage(user: user.right) : Intro());
        });
  }
}
