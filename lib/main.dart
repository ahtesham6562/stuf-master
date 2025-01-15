import 'package:flutter/material.dart';
import 'package:stuff/Loginpage.dart';
import 'package:stuff/explore.dart';
import 'package:stuff/home.dart';
import 'package:stuff/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firebase Auth",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        "/Homepage": (BuildContext context) => Home(),
        "/loginpage": (BuildContext context) => LoginPage(),
        "/signup": (BuildContext context) => SignUpPage(),
        "/carry": (BuildContext context) => ExploreStuff(flipScreenCtrl: null, key: null,),
      },
    );
  }
}
