import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamy/MainHome.dart';
import 'package:streamy/chat_feature/controller/chat_controller.dart';
import 'package:streamy/chat_feature/data_source/chat_data_source.dart';
import 'package:streamy/chat_feature/repo/chat_logic.dart';
import 'package:streamy/chat_feature/screens/call_page.dart';
import 'package:streamy/constants.dart';
import 'package:streamy/repo/auth_logic.dart';
import 'package:streamy/repo/firestore_logic.dart';
import 'package:streamy/services/Cache_Helper.dart';
import 'package:streamy/services/Navigation_Service.dart';
import 'package:streamy/services/NotificationHandler/notification_handler.dart';
import 'controller/auth_controller.dart';
import 'controller/firestore_controller.dart';
import 'datasource/auth_data.dart';
import 'datasource/firestore_data.dart';
import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final navigator = NavigationService();
  await CacheData.cacheInitialization();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationHandler.instance.init(navigator).then((_) async {
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

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context, listen: false);
    bool isCall = Provider.of<ChatController>(context).isCall;
    log(isCall.toString());
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: primaryColor,
          primaryColor: primaryColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: mainBlueColor, foregroundColor: Colors.white)),
      home: (chatController.chatRoomId != null &&
              chatController.channelKey != null)
          ? CallPage(
              chatRoomID: chatController.chatRoomId!,
              channelKey: chatController.channelKey!)
          : MainHome(
              isCall: isCall,
            ),
    );
  }
}
