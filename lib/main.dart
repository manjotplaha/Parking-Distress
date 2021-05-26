import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/view_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fbm = FirebaseMessaging();
  fbm.getToken().then((value) => print('valuue of token $value'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
            // primarySwatch: Colors.white,
            // backgroundColor: Colors.white,
            // accentColor: Colors.deepPurple,
            // accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
                // buttonColor: Colors.pink,
                // textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            //if firebase found the token of user
            if (userSnapshot.hasData) {
              return ViewSelector();
            }
            return AuthScreen();
          },
        )
        // home: ViewSelector(),
        );
  }
}
