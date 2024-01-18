import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/auth/login.dart';
import 'package:notes/auth/signup.dart';
import 'package:notes/categories/add.dart';

import 'categories/edit.dart';
import 'homepage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class DefaultFirebaseOptions {
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('===================================User is currently signed out!========================');
      } else {
        print('===================================User is signed in!========================');
      }
    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade50,
          titleTextStyle: TextStyle(
            color:Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.orange,
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home:(FirebaseAuth.instance.currentUser != null &&
      FirebaseAuth.instance.currentUser!.emailVerified
      )? HomePage() : LogIn(),
      routes: {
        "Signup" : (context) => SignUp(),
        "Login" : (context) => LogIn(),
        "Homepage" : (context) => HomePage(),
        "Addcategor" : (context) => AddCategor(),

      },
    );
  }
}
