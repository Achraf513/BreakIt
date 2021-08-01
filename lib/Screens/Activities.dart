import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:intl/intl.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final _sharedData = SharedData();
  DateTime dayFilter= DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  
  String? getCategory(
      ApplicationCategory appCategory, bool isSysApp, bool forDataBase) {
    if (!forDataBase) {
      if (isSysApp) {
        return SharedData().dictionary[Shared.selectedLanguage]?["System"];
      }
      switch (appCategory) {
        case ApplicationCategory.audio:
          return SharedData().dictionary[Shared.selectedLanguage]?["Audio"];
        case ApplicationCategory.game:
          return SharedData().dictionary[Shared.selectedLanguage]?["Game"];
        case ApplicationCategory.image:
          return SharedData().dictionary[Shared.selectedLanguage]?["Image"];
        case ApplicationCategory.maps:
          return SharedData().dictionary[Shared.selectedLanguage]
              ?["Navigation"];
        case ApplicationCategory.news:
          return SharedData().dictionary[Shared.selectedLanguage]?["News"];
        case ApplicationCategory.productivity:
          return SharedData().dictionary[Shared.selectedLanguage]
              ?["Productivity"];
        case ApplicationCategory.social:
          return SharedData().dictionary[Shared.selectedLanguage]?["Social"];
        case ApplicationCategory.video:
          return SharedData().dictionary[Shared.selectedLanguage]?["Video"];
        default:
          return SharedData().dictionary[Shared.selectedLanguage]?["Unkown"];
      }
    }
    if (isSysApp) {
      return "System";
    }
    switch (appCategory) {
      case ApplicationCategory.audio:
        return "Audio";
      case ApplicationCategory.game:
        return "Game";
      case ApplicationCategory.image:
        return "Image";
      case ApplicationCategory.maps:
        return "Navigation";
      case ApplicationCategory.news:
        return "News";
      case ApplicationCategory.productivity:
        return "Productivity";
      case ApplicationCategory.social:
        return "Social";
      case ApplicationCategory.video:
        return "Video";
      default:
        return "Unkown";
    }
  }

  @override
  Widget build(BuildContext context) {
    _sharedData.totalUsage = 0;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),borderSide : BorderSide(color: Color(Shared.color_primary1), width: 0.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),borderSide : BorderSide(color: Color(Shared.color_primary1), width: 1)),
                      filled: true,
                      prefixIcon: Icon(Icons.search_rounded, color: Color(Shared.color_primary1),),
                      fillColor: Colors.white,
                      hintText: SharedData().dictionary[Shared.selectedLanguage]?["Search by application"]??"Search by application",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(Shared.color_primary1).withAlpha(128)
                      )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Shared.color_primary2)),
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child:Icon(Icons.arrow_back_ios_new_rounded,color: dateFormat.format(dayFilter.subtract(Duration(days: 1)))!=dateFormat.format(DateTime.now().subtract(Duration(days: 6)))?Color(Shared.color_primary1):Colors.grey,),
                            onTap: (){
                              if(dateFormat.format(dayFilter.subtract(Duration(days: 1)))!=dateFormat.format(DateTime.now().subtract(Duration(days: 6)))){ // add only 7 days possible rotation
                                setState(() {
                                  dayFilter = dayFilter.subtract(Duration(days: 1));
                                });
                              } 
                            },
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Center(child: Text(
                              dateFormat.format(dayFilter.subtract(Duration(days: 1))),
                              style: TextStyle(color: Color(Shared.color_primary1)),
                            ))),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Icon(Icons.arrow_forward_ios_rounded,color: dateFormat.format(dayFilter.subtract(Duration(days: 1)))==dateFormat.format(DateTime.now())?Colors.grey:Color(Shared.color_primary1)),
                            onTap: (){
                              if(dateFormat.format(dayFilter.subtract(Duration(days: 1)))!=dateFormat.format(DateTime.now())){
                                setState(() {
                                  dayFilter = dayFilter.add(Duration(days: 1));
                                });
                              } 
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                FutureBuilder(
                    future: _sharedData.getDailyUsageStats(dayFilter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occured',
                              style: TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final data = snapshot.data as List<AppDailyInfo>;
                          return Column(
                              children: data.reversed.where((element) => element.usageInMin>0)
                                  .map(
                                    (e) => FutureBuilder(
                                        future: _sharedData.getIcon(e.appPackageName),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  '${snapshot.error} occured',
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              );
                                            } else if (snapshot.hasData) {
                                              Application appSecondaryData =
                                                  snapshot.data as Application;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(
                                                      Shared.color_primary2),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 15, vertical: 10),
                                                margin: const EdgeInsets.fromLTRB(
                                                    20, 5, 20, 0),
                                                height: 125,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [

                                                        //App Icon and Name
                                                        //App Icon and Name
                                                        Expanded(
                                                          flex: 6,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  child: appSecondaryData
                                                                          is ApplicationWithIcon
                                                                      ? Image.memory(
                                                                          appSecondaryData
                                                                              .icon)
                                                                      : Icon(Icons
                                                                          .android_rounded)),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    appSecondaryData.appName,
                                                                    style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Color(Shared.color_primary1)
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: SizedBox(),
                                                        ),

                                                        //Status of the advancement 
                                                        //Status of the advancement 
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                              color: Colors
                                                                  .lightGreen
                                                                  .withOpacity(0.5),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .arrow_downward_rounded,
                                                                  color: Colors
                                                                          .lightGreen[
                                                                      700],
                                                                      size: 15,
                                                                ),
                                                                Text("12%",
                                                                    style:
                                                                        TextStyle(
                                                                          fontSize: 12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                              .lightGreen[
                                                                          700],
                                                                    ))
                                                              ],
                                                            ),
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                          Expanded(
                                                            flex : 5,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text:  (SharedData().dictionary[Shared.selectedLanguage]?["Usage Percentage"]??"Usage Percentage")+" : ",
                                                                style: TextStyle(
                                                                  color: Color(Shared.color_primary1),
                                                                  fontSize: 12,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(text:  e.usagePerc.toString()+"%", style: TextStyle(fontWeight: FontWeight.w600)),
                                                                ],
                                                              ),
                                                            )
                                                            
                                                          ),
                                                          SizedBox(width: 25,),
                                                          Expanded(
                                                            flex: 4,
                                                            child: 
                                                            RichText(
                                                              text: TextSpan(
                                                                text: (SharedData().dictionary[Shared.selectedLanguage]?["Used For"]??"Used For") + " : ",
                                                                style: TextStyle(
                                                                  color: Color(Shared.color_primary1),
                                                                  fontSize: 12,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(text:  
                                                                    (e.usageInMin~/60) != 0?
                                                                    (e.usageInMin~/60).toString() +"h"+ ((e.usageInMin%60)!=0? (e.usageInMin%60).toString() +"min":""):
                                                                    (e.usageInMin%60).toString() +"min"
                                                                  
                                                                  , style: TextStyle(fontWeight: FontWeight.w600)),
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                        ],),
                                                        SizedBox(height: 5,),
                                                        
                                                        RichText(
                                                              text: TextSpan(
                                                                text:  (SharedData().dictionary[Shared.selectedLanguage]?["Category"]??"Category")+" : ",
                                                                style: TextStyle(
                                                                  color: Color(Shared.color_primary1),
                                                                  fontSize: 12,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(text: getCategory(appSecondaryData.category, appSecondaryData.systemApp, false), style: TextStyle(fontWeight: FontWeight.w600)),
                                                                ],
                                                              ),
                                                            )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          } else {
                                            return SizedBox();
                                          }
                                        }),
                                  )
                                  .toList());
                        } else
                          return Center(
                              child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: Container(
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(Shared.color_primary1)),
                                ),
                              ),
                            ),
                          ));
                      } else
                        return Center(
                            child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.width / 3,
                              width: MediaQuery.of(context).size.width / 3,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(Shared.color_primary1)),
                              ),
                            ),
                          ),
                        ));
                    }),
              ],
            ))

        /* Column(
          children: [
            SizedBox(height: 50,),
            Column(
            children: _infos.map((e) => 
              Container(
                margin: EdgeInsets.all(8),
                child: Column(
                children: [
                  Text(e.appName,style: TextStyle(fontSize: 20,color: Colors.green),),
                  Text(e.usage.inHours.toString(),style: TextStyle(fontSize: 10),),
                  Text(e.packageName,style: TextStyle(fontSize: 10),),
                ],
              ))
            ).toList(),
              ),
          ],
        ), */
        );
  }
}
