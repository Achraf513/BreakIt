import 'dart:ui';

import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Screens/dashboard2.dart';
import 'package:break_it/Screens/Activities.dart';
import 'package:break_it/Screens/rules.dart';
import 'package:break_it/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageId = 0;
  PageController pageController = PageController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        return AlertDialog(
          backgroundColor: Shared.darkThemeOn ? Colors.white70 : Colors.black87,
          title: Text(
            'Calculating',
            style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please wait till the processing ends.',
                  style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Okay',
                style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> screenTitle = [
      SharedData().dictionary[Shared.selectedLanguage]?["Usage Dashboard"] ??
          "Usage Dashboard",
      SharedData().dictionary[Shared.selectedLanguage]?["Activities"] ??
          "Activities",
      SharedData().dictionary[Shared.selectedLanguage]?["Rules"] ?? "Rules",
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.colorUi),
        title: Text(
          screenTitle[currentPageId],
        ),
        leading: IconButton(
          onPressed: () {
            if (Shared.blockUser) {
              _showMyDialog();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ).then((value) {
                setState(() {});
              });
            }
          },
          icon: SvgPicture.asset(
            "assets/icons/Settings_outlined.svg",
            height: 24,
            width: 24,
          ),
        ),
      ),
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            currentPageId = value;
          });
        },
        controller: pageController,
        children: [DashboardScreen(), ActivitiesScreen(), RulesScreen()],
      ),
      bottomNavigationBar: Container(
        color: Color(Shared.colorUi),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: [
            buildBottomNavElement("assets/icons/PieChart_outlined.svg",
                "assets/icons/PieChart_filled.svg", 0),
            buildBottomNavElement("assets/icons/Rules_outlined.svg",
                "assets/icons/Rules_filled.svg", 1),
            buildBottomNavElement("assets/icons/Activities_outlined.svg",
                "assets/icons/Activities_filled.svg", 2),
          ],
        ),
      ),
    );
  }

  Expanded buildBottomNavElement(String outlined, String filled, int id) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: GestureDetector(
          onTap: () {
            if(currentPageId!=id){
            if (Shared.blockUser) {
              _showMyDialog();
            } else {
              setState(() {
                currentPageId = id;
                pageController.jumpToPage(currentPageId);
              });
            }}
          },
          child: Container(
            height: 26,
            child: SvgPicture.asset(id == currentPageId ? filled : outlined),
          ),
        ),
      ),
    );
  }
}
