import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/data_source/chat_data_source.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/constants.dart';
import 'package:streamy/repo/auth_logic.dart';
import 'package:streamy/repo/firestore_logic.dart';
import 'package:streamy/services/Cache_Helper.dart';
import 'package:streamy/services/Navigation_Service.dart';
import 'package:streamy/services/NotificationHandler/notification_handler.dart';
import 'package:streamy/views/admin_loadingCheck.dart';
import 'package:streamy/views/onBoarding.dart';

import 'controller/auth_controller.dart';
import 'controller/firestore_controller.dart';
import 'datasource/auth_data.dart';
import 'datasource/firestore_data.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final navigator = NavigationService();
  await CacheData.cacheInitialization();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationHandler.instance.init(navigator).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FireStoreController(
              firestorehandlerImplement: FirestorehandlerImplement(
                cacheData: CacheData(),
                firestoreImplement: FirestoreImplement(
                  firebaseFirestore: FirebaseFirestore.instance,
                ),
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthController(
              repo: AuthHandlerImplement(
                authImplement:
                    AuthImplement(firebaseAuth: FirebaseAuth.instance),
                cacheData: CacheData(),
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => ChatController(
              chatRepo: ChatHandlerImplement(
                chatImplement: ChatImplement(
                    firebaseFirestore: FirebaseFirestore.instance),
                cacheData: CacheData(),
              ),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Either<String, MyUser> user =
        Provider.of<AuthController>(context, listen: false).getCurrentUser();
    //todo step 1 check if app is opened by a notification using a bool read from a provider
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          log("running material app", name: "materialApp");
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: appBackGroundColor,
            ),
            home:
                user.isRight ? AdminCheckPage(user: user.right) : const Intro(),
          );
        });
  }
}
