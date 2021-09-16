import 'package:break_it/Screens/About.dart';
import 'package:break_it/Screens/GeneralNotifications.dart';
import 'package:break_it/Screens/ReportABug.dart';
import 'package:break_it/Screens/SendFeedBack.dart';
import 'package:break_it/Screens/selectLanguage.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.colorUi),
        title: Text(SharedData().dictionary[Shared.selectedLanguage]?["Settings"]??"Settings",),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]?["General"]??"General",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(Shared.colorPrimaryText),
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder :(context)=>SelectLanguageScreen())).then((value){
                        setState((){});
                      });
                    },
                    child: Container(
                      padding:EdgeInsets.symmetric(vertical:15),
                    color: Color(Shared.colorPrimaryBackGround),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.translate_sharp,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  SharedData().dictionary[Shared.selectedLanguage]?["Language"]??"Language",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.colorPrimaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.colorPrimaryText),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160), height:0),
                ],
              ),
            ),
            GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>GeneralNotifications()));
             },
              child: Container(
                      color: Color(Shared.colorPrimaryBackGround),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding:EdgeInsets.symmetric(vertical:15),
                      color: Color(Shared.colorPrimaryBackGround),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications_on_outlined,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  SharedData().dictionary[Shared.selectedLanguage]?["Notifications"]??"Notifications",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.colorPrimaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.colorPrimaryText),
                              )),
                        ],
                      ),
                    ), 
                    Divider(color: Color(Shared.colorPrimaryText).withAlpha(160), height:0),
                  ],
                ),
              ),
            ),
            Container( 
              child: Column(
                children: [
                  Container(
                    width: double.infinity, 
                      color:Color(Shared.colorPrimaryBackGround),
                    padding:EdgeInsets.symmetric(vertical:15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_border_rounded,
                                color: Color(Shared.colorPrimaryText),
                              ),
                              SizedBox(width: 10),
                              Text(
                                SharedData().dictionary[Shared.selectedLanguage]?["Rate Us"]??"Rate Us",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(Shared.colorPrimaryText),
                            )),
                      ],
                    ),
                  ), 
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160),height: 0,),
                ],
              ),
            ),
            Container( 
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutScreen()));
                    },
                    child: Container(
                      width: double.infinity, 
                      color:Color(Shared.colorPrimaryBackGround),
                      padding:EdgeInsets.symmetric(vertical:15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.help_outline_rounded,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  SharedData().dictionary[Shared.selectedLanguage]?["About"]??"About",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.colorPrimaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.colorPrimaryText),
                              )),
                        ],
                      ),
                    ),
                  ), 
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160),height: 0,),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity, 
                      color:Color(Shared.colorPrimaryBackGround),
                    padding:EdgeInsets.symmetric(vertical:15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Row(
                            children: [
                              Icon(
                                Icons.dark_mode_outlined,
                                color: Color(Shared.colorPrimaryText),
                              ),
                              SizedBox(width: 10),
                              Text(
                                SharedData().dictionary[Shared.selectedLanguage]?["Dark Theme"]??"Dark Theme",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  Shared.darkThemeOn = !Shared.darkThemeOn;
                                  DataBase.instance.updateDarkModeOn();
                                  Shared.flipTheme();
                                });
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.centerStart,
                                children: [
                                  Container(
                                      height: 25,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(color: Color(Shared.colorPrimaryText),width: 0.5),
                                          color: Color(Shared.colorPrimaryBackGround)),),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Shared.darkThemeOn?28:2,
                                      ),
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Color(Shared.colorPrimaryText)))
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160),height: 0,),
                ],
              ),
            ),
            SizedBox(height:30),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]?["FeedBack"]??"FeedBack",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(Shared.colorPrimaryText),
              ),
            ),
            SizedBox(height: 15),

             Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportABug()));
                    },
                    child: Container(
                    width: double.infinity, 
                      color:Color(Shared.colorPrimaryBackGround),
                    padding:EdgeInsets.symmetric(vertical:15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  SharedData().dictionary[Shared.selectedLanguage]?["Report a bug"]??"Report a bug",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.colorPrimaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.colorPrimaryText),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160),height:0),
                ],
              ),
            ),
             Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap : (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SendFeedBack()));
                    },
                    child: Container( 
                    width: double.infinity, 
                    color:Color(Shared.colorPrimaryBackGround),
                    padding:EdgeInsets.symmetric(vertical:15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.send_outlined,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  SharedData().dictionary[Shared.selectedLanguage]?["Send FeedBack"]??"Send FeedBack",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.colorPrimaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.colorPrimaryText),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Color(Shared.colorPrimaryText).withAlpha(160),height:0),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
