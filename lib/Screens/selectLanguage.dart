import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(Shared.color_primary1),
          title: Text("Settings"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
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
                        "Language",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(Shared.color_primary1),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        color: Shared.selectedLanguage=="English"?Colors.grey[200]:Colors.white,
                        child: Column(
                          children: [
                            Divider(height: 0,),
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     Shared.selectedLanguage = "English";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width:5),
                                        Container(child: SvgPicture.asset("assets/icons/uk_icon.svg"),width: 30,height: 30,),
                                        SizedBox(width: 15),
                                        Text(
                                          "English",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(Shared.color_primary1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(height:0)
                          ],
                        ),
                      ),
                      Container(
                        color: Shared.selectedLanguage=="French"?Colors.grey[200]:Colors.white,
                        child: Column(
                          children: [
                            Divider(height: 0,),
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     Shared.selectedLanguage = "French";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width:5),
                                        Container(child: SvgPicture.asset("assets/icons/france_icon.svg"),width: 30,height: 30,),
                                        SizedBox(width: 15),
                                        Text(
                                          "French",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(Shared.color_primary1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(height:0)
                          ],
                        ),
                      ),
                      
                      Container(
                        color: Shared.selectedLanguage=="Spanish"?Colors.grey[200]:Colors.white,
                        child: Column(
                          children: [
                            Divider(height: 0,),
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     Shared.selectedLanguage = "Spanish";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width:5),
                                        Container(child: SvgPicture.asset("assets/icons/spain_icon.svg"),width: 30,height: 30,),
                                        SizedBox(width: 15),
                                        Text(
                                          "Spanish",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(Shared.color_primary1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(height:0)
                          ],
                        ),
                      ),
                      
                      Container(
                        color: Shared.selectedLanguage=="German"?Colors.grey[200]:Colors.white,
                        child: Column(
                          children: [
                            Divider(height: 0,),
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     Shared.selectedLanguage = "German";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width:5),
                                        Container(child: SvgPicture.asset("assets/icons/germany_icon.svg"),width: 30,height: 30,),
                                        SizedBox(width: 15),
                                        Text(
                                          "German",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(Shared.color_primary1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(height:0)
                          ],
                        ),
                      ),
                    ]))));
  }
}
