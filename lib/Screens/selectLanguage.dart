import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  SharedData sharedInstance = SharedData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(Shared.colorPrimaryBackGround),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(Shared.colorUi),
          title: Text(sharedInstance.dictionary[Shared.selectedLanguage]
                  ?["Settings"] ??
              "Settings"),
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
                        sharedInstance.dictionary[Shared.selectedLanguage]
                                ?["Language"] ??
                            "Language",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(Shared.colorPrimaryText),
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Shared.selectedLanguage = "English";
                             DataBase.instance.updateSelectedLanguage();
                          });
                        },
                        child: Container(
                          color: Shared.selectedLanguage == "English"
                              ? Color(Shared.colorSecondaryBackGround)
                              : Color(Shared.colorPrimaryBackGround),
                          child: Column(
                            children: [
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Container(
                                          child: SvgPicture.asset(
                                              "assets/icons/uk_icon.svg"),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          sharedInstance.dictionary[
                                                      Shared.selectedLanguage]
                                                  ?["English"] ??
                                              "English",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color(Shared.colorPrimaryText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Shared.selectedLanguage = "French";
                             DataBase.instance.updateSelectedLanguage();
                          });
                        },
                        child: Container(
                          color: Shared.selectedLanguage == "French"
                              ? Color(Shared.colorSecondaryBackGround)
                              : Color(Shared.colorPrimaryBackGround),
                          child: Column(
                            children: [
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Container(
                                          child: SvgPicture.asset(
                                              "assets/icons/france_icon.svg"),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          sharedInstance.dictionary[
                                                      Shared.selectedLanguage]
                                                  ?["French"] ??
                                              "French",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color(Shared.colorPrimaryText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(()  {
                            Shared.selectedLanguage = "Spanish";
                             DataBase.instance.updateSelectedLanguage();
                          });
                        },
                        child: Container(
                          color: Shared.selectedLanguage == "Spanish"
                              ? Color(Shared.colorSecondaryBackGround)
                              : Color(Shared.colorPrimaryBackGround),
                          child: Column(
                            children: [
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Container(
                                          child: SvgPicture.asset(
                                              "assets/icons/spain_icon.svg"),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          sharedInstance.dictionary[
                                                      Shared.selectedLanguage]
                                                  ?["Spanish"] ??
                                              "Spanish",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color(Shared.colorPrimaryText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Shared.selectedLanguage = "German";
                            DataBase.instance.updateSelectedLanguage();
                          });
                        },
                        child: Container(
                          color: Shared.selectedLanguage == "German"
                              ? Color(Shared.colorSecondaryBackGround)
                              : Color(Shared.colorPrimaryBackGround),
                          child: Column(
                            children: [
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Container(
                                          child: SvgPicture.asset(
                                              "assets/icons/germany_icon.svg"),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          sharedInstance.dictionary[
                                                      Shared.selectedLanguage]
                                                  ?["German"] ??
                                              "German",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color(Shared.colorPrimaryText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 0,
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160))
                            ],
                          ),
                        ),
                      ),
                    ]))));
  }
}
