import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:flutter/material.dart';

class GeneralNotifications extends StatefulWidget {
  const GeneralNotifications({ Key? key }) : super(key: key);

  @override
  _GeneralNotificationsState createState() => _GeneralNotificationsState();
}

class _GeneralNotificationsState extends State<GeneralNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.colorUi),
        title: Text(
          SharedData().dictionary[Shared.selectedLanguage]?["Notifications"] ??
              "Notifications",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 20,),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]?["Notify me :"]??"Notify me :",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Color(Shared.colorPrimaryText)),
            ),
            SizedBox(height: 15,),
            ////////////////////////////////////
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
                              Text(
                                SharedData().dictionary[Shared.selectedLanguage]?["If today's time on exceeded the average"]??"If today's time on exceeded the average",
                                style: TextStyle(
                                  fontSize: 14,
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
                                  Shared.notifyTodayExceededAvarege = !Shared.notifyTodayExceededAvarege;
                                  DataBase.instance.updateNotifyTodayExceededAvarege();
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
                                        width: Shared.notifyTodayExceededAvarege?28:2,
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
            
            ///////////////////////
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
                              Text(
                                SharedData().dictionary[Shared.selectedLanguage]?["5 min before the usage limit reaches"]??"5 min before the usage limit reaches",
                                style: TextStyle(
                                  fontSize: 14,
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
                                  Shared.notifyEarlier = !Shared.notifyEarlier;
                                  DataBase.instance.updateNotifyEarlier();
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
                                        width: Shared.notifyEarlier?28:2,
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
          ],),
        )
      )
    );
  }
}