import 'package:break_it/Screens/grantPermession.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  await Shared().initShared();
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
    return GrantPermession();
  }
}
