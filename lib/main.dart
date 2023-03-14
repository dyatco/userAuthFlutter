import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_auth/login_widget.dart';
import 'package:login_auth/utils.dart';
import 'package:login_auth/Pages/home_page.dart';
import 'package:login_auth/Pages/auth_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final String title = 'Setup Firebase';

  @override
  Widget build(BuildContext context) => MaterialApp(
    scaffoldMessengerKey: Utils.messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(secondary: Colors.tealAccent),
    ),
    home: MainPage(),
  );
}

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        // loading indicator
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        // error message
        } else if (snapshot.hasError){
          return Center(child: Text('Something went wrong'));
        // if logged in, go to homepage
        } else if (snapshot.hasData){
          return HomePage();
        // if logged out, go to login page
        } else {
          return AuthPage();
        }
      },
    ),
  );
}