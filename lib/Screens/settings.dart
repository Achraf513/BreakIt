import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _sharedData = SharedData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.color_primaryViolet),
        title: Text("Settings"),
        leading: IconButton(
          onPressed: () {},
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
              "General",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(Shared.color_primaryViolet),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.translate_sharp,
                              color: Color(Shared.color_primaryViolet),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Language",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(Shared.color_primaryViolet),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(Shared.color_primaryViolet),
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_on_outlined,
                              color: Color(Shared.color_primaryViolet),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(Shared.color_primaryViolet),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(Shared.color_primaryViolet),
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_border_rounded,
                              color: Color(Shared.color_primaryViolet),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Rate Us",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(Shared.color_primaryViolet),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(Shared.color_primaryViolet),
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.help_outline_rounded,
                              color: Color(Shared.color_primaryViolet),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "About",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(Shared.color_primaryViolet),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(Shared.color_primaryViolet),
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.dark_mode_outlined,
                              color: Color(Shared.color_primaryViolet),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Dark Theme",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(Shared.color_primaryViolet),
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
                                        color:
                                            Color(Shared.color_secondaryGrey))),
                                Positioned(
                                  right: 10,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
            SizedBox(height:30),
            Text(
              "FeedBack",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(Shared.color_primaryViolet),
              ),
            ),
            SizedBox(height: 15),

             Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      //Report a bug 
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Color(Shared.color_primaryViolet),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Report a bug",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.color_primaryViolet),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.color_primaryViolet),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
             Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: [
                  GestureDetector(
                    onTap : (){
                      
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.send_outlined,
                                  color: Color(Shared.color_primaryViolet),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Send FeedBack",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(Shared.color_primaryViolet),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(Shared.color_primaryViolet),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider()
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
