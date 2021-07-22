import 'package:break_it/Screens/HomeScreen.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Screens/dashboard.dart';
import 'package:break_it/Screens/activities.dart';
import 'package:break_it/Screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BreakIt', 
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);  

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> { 

  @override
  Widget build(BuildContext context) {
    //return GetDataTest();
    return HomeScreen();
    //return SplashScreen();
  }
}
