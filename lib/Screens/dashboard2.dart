import 'dart:math';

import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/Weekly.dart';
import 'package:break_it/Models/dailyCategory.dart';
import 'package:break_it/Models/generalData.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static DateTime startOfTheWeek = DateTime.now();
  late DateFormat dateFormat;
  int selectedFilterId = 0;
  int totalAvarageUsage = 0;
  static SharedData sharedInstance = SharedData();

  List<int> monthlyUsage = [];
  DateTime dayFilter = DateTime.now()
      .subtract(
          Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute))
      .add(Duration(days: 1));

  static final _sharedData = SharedData();

  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    startOfTheWeek =
        now.subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfTheWeek.weekday != DateTime.monday) {
      startOfTheWeek = startOfTheWeek.subtract(Duration(days: 1));
    }
    initializeDateFormatting();
    dateFormat = DateFormat("dd MMMM","en");
  }

  static String? getCategory(
      ApplicationCategory appCategory, bool isSysApp, bool forDataBase) {
    if (!forDataBase) {
      if (isSysApp) {
        return sharedInstance.dictionary[Shared.selectedLanguage]?["System"];
      }
      switch (appCategory) {
        case ApplicationCategory.audio:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Audio"];
        case ApplicationCategory.game:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Game"];
        case ApplicationCategory.image:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Image"];
        case ApplicationCategory.maps:
          return sharedInstance.dictionary[Shared.selectedLanguage]
              ?["Navigation"];
        case ApplicationCategory.news:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["News"];
        case ApplicationCategory.productivity:
          return sharedInstance.dictionary[Shared.selectedLanguage]
              ?["Productivity"];
        case ApplicationCategory.social:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Social"];
        case ApplicationCategory.video:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Video"];
        default:
          return sharedInstance.dictionary[Shared.selectedLanguage]?["Unkown"];
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

 
  static Future updateTodaysData() async {
    DateTime today = DateTime.now().subtract(
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
    List<AppUsageInfo> infos = await _sharedData.getUsageStats(
        today, today.add(Duration(days: 1)), false);
    double totalUsageLocal = 0;
    for (var app in infos) {
      Application? moreDetails = await DeviceApps.getApp(app.packageName);
      if (moreDetails != null) {
        if (!moreDetails.systemApp) {
          totalUsageLocal += app.usage.inMinutes;
        }
      }
    }
    totalUsageLocal = totalUsageLocal / 60 < 14
        ? totalUsageLocal / 60
        : 2 + Random().nextDouble() * 10;

    WeeklyInfo? todaysWeeklyInfo =
        await DataBase.instance.getTodaysWeeklyInfo();

    if (todaysWeeklyInfo != null) {
      WeeklyInfo weeklyInfo = WeeklyInfo(
        id: todaysWeeklyInfo.id,
        idWeek: startOfTheWeek.day.toString() +
            startOfTheWeek.month.toString() +
            startOfTheWeek.add(Duration(days: 6)).day.toString() +
            startOfTheWeek.add(Duration(days: 6)).month.toString() +
            startOfTheWeek.year.toString(),
        idDay: today.year.toString() +
            today.month.toString() +
            today.day.toString(),
        usageInHours: totalUsageLocal,
        pos: todaysWeeklyInfo.pos,
      );
      DataBase.instance.updateWeeklyInfo(weeklyInfo);
    }
  }
  List<WeeklyInfo> filterUnique(List<WeeklyInfo> data){
    Map<double,WeeklyInfo> newData = {};
    for(WeeklyInfo weeklyInfo in data){
      if(newData.keys.contains(weeklyInfo.pos)){
        continue;
      }
      newData[weeklyInfo.pos] = weeklyInfo;
    }
    return newData.values.toList();
  }
  static Future<List<WeeklyInfo>> getWeeklyUsage() async {
    List<List<double>> weeklyUsage = [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0],
      [4, 0],
      [5, 0],
      [6, 0]
    ];
    String idWeek = startOfTheWeek.day.toString() +
        startOfTheWeek.month.toString() +
        startOfTheWeek.add(Duration(days: 6)).day.toString() +
        startOfTheWeek.add(Duration(days: 6)).month.toString() +
        startOfTheWeek.year.toString();

    List<WeeklyInfo>? result = await DataBase.instance.readWeeklyInfo(idWeek);
    if (result != null) {
      Generaldata? lastCheck = await DataBase.instance.getGeneralData("LastCheckDashBoard");
      if (lastCheck != null) {
        if (DateTime.now()
            .subtract(Duration(minutes: 10))
            .isAfter(DateTime.parse(lastCheck.data))) {
          await updateTodaysData();
          await DataBase.instance.updateLastCheckDashBoard();
        }
      }
      result = await DataBase.instance.readWeeklyInfo(idWeek);
      if (result != null) {
        return result;
      } else
        return [];
    } else {
      result = [];
      for (var i = 0; i < 7; i++) {
        List<AppUsageInfo> infos = await _sharedData.getUsageStats(
            startOfTheWeek.add(Duration(days: i)),
            startOfTheWeek.add(Duration(days: i + 1)),
            false);
        int totalUsageLocal = 0;
        for (var app in infos.reversed) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          if (moreDetails != null) {
            if (!moreDetails.systemApp) {
              DataBase.instance.updateDailyCategory(DailyCategory(
                  idWeek: startOfTheWeek.day.toString() +
                      startOfTheWeek.month.toString() +
                      startOfTheWeek.add(Duration(days: 6)).day.toString() +
                      startOfTheWeek.add(Duration(days: 6)).month.toString() +
                      startOfTheWeek.year.toString(),
                  idDay: startOfTheWeek.add(Duration(days: i)).year.toString() +
                      startOfTheWeek.add(Duration(days: i)).month.toString() +
                      startOfTheWeek.add(Duration(days: i)).day.toString(),
                  category: getCategory(moreDetails.category, false, true) ??
                      "Unkown",
                  usageInMin: app.usage.inMinutes));
              totalUsageLocal += app.usage.inMinutes;
            }
          }
        }
        weeklyUsage[i][1] = totalUsageLocal / 60 < 14
            ? totalUsageLocal / 60
            : 6 + Random().nextDouble() * 4;

        WeeklyInfo weeklyInfo = WeeklyInfo(
            idWeek: startOfTheWeek.day.toString() +
                startOfTheWeek.month.toString() +
                startOfTheWeek.add(Duration(days: 6)).day.toString() +
                startOfTheWeek.add(Duration(days: 6)).month.toString() +
                startOfTheWeek.year.toString(),
            idDay: startOfTheWeek.add(Duration(days: i)).year.toString() +
                startOfTheWeek.add(Duration(days: i)).month.toString() +
                startOfTheWeek.add(Duration(days: i)).day.toString(),
            usageInHours: weeklyUsage[i][1],
            pos: weeklyUsage[i][0]);
        if (infos.length != 0) {
          DataBase.instance.createWeeklyInfo(weeklyInfo);
          result.add(weeklyInfo);
        }
      }
      return result;
    }
  }

//adb shell pm dump com.facebook.katana | grep 'lastTimeUsed' | tail -1
//adb shell pm dump com.facebook.katana | grep 'RESUMED' | tail -1 | cut -c10-30
  @override
  Widget build(BuildContext context) {
    Shared.blockUser = true;
    String local = "en";
    switch(Shared.selectedLanguage){
      case "English":
        local = "en";
        break;
      case "Dutch":
        local = "de_AT";
        break;
      case "French":
        local = "fr";
        break;
      case "Spanish":
        local = "es_US";
        break;
    }
    dateFormat = DateFormat("dd MMMM",local);
    _sharedData.totalUsage = 0;
    return Scaffold(
        backgroundColor: Color(Shared.colorPrimaryBackGround),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                // Button-Controller
                // Button-Controller

                /* Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(Shared.color_primaryViolet)),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFilterButton("Weekly", 0),
                  buildFilterButton("Monthly", 1),
                ],
              ),
            ), 
            SizedBox(
              height: 10,
            ),
            */

                // Date Filter-Controller
                // Date Filter-Controller
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  Shared.blockUser = true;
                  String idWeek = startOfTheWeek.day.toString() +
                      startOfTheWeek.month.toString() +
                      startOfTheWeek.add(Duration(days: 6)).day.toString() +
                      startOfTheWeek.add(Duration(days: 6)).month.toString() +
                      startOfTheWeek.year.toString();
                  DateTime now = DateTime.now();
                  DateTime startOfThisWeek = now
                      .subtract(Duration(hours: now.hour, minutes: now.minute));
                  while (startOfThisWeek.weekday != DateTime.monday) {
                    startOfThisWeek =
                        startOfThisWeek.subtract(Duration(days: 1));
                  }
                  String idThisWeek = startOfThisWeek.day.toString() +
                      startOfThisWeek.month.toString() +
                      startOfThisWeek.add(Duration(days: 6)).day.toString() +
                      startOfThisWeek.add(Duration(days: 6)).month.toString() +
                      startOfThisWeek.year.toString();

                  return Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(Shared.colorSecondaryBackGround)),
                          width: double.infinity,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!Shared.blockUser) {
                                        setState(() {
                                          startOfTheWeek = startOfTheWeek
                                              .subtract(Duration(days: 7));
                                        });
                                      }
                                    },
                                    child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Color(Shared.colorPrimaryText)),
                                  ),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Center(
                                        child: Text(
                                      dateFormat.format(startOfTheWeek) +
                                          " - " +
                                          dateFormat.format(startOfTheWeek
                                              .add(Duration(days: 6))) +
                                          " : " +
                                          startOfTheWeek.year.toString(),
                                      style: TextStyle(
                                          color:
                                              Color(Shared.colorPrimaryText)),
                                    ))),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                      onTap: () {
                                        if (idThisWeek != idWeek &&
                                            !Shared.blockUser) {
                                          setState(() {
                                            startOfTheWeek = startOfTheWeek
                                                .add(Duration(days: 7));
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: (idThisWeek != idWeek)
                                            ? Color(Shared.colorPrimaryText)
                                            : Colors.grey,
                                      )),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      FutureBuilder(
                          future: getWeeklyUsage(),
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
                                List<WeeklyInfo> data = snapshot.data as List<WeeklyInfo>;
                                data = filterUnique(data);
                                Shared.blockUser = false;
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  width: double.infinity,
                                  height: 160,
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: LineChart(LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                                color: Color(
                                                        Shared.colorPrimaryText)
                                                    .withAlpha(128),
                                                strokeWidth: 0.25);
                                          },
                                        ), //2mk6RpQJ
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.25,
                                                color: Color(
                                                        Shared.colorPrimaryText)
                                                    .withAlpha(128)),
                                            top: BorderSide(
                                                width: 0.25,
                                                color: Color(
                                                        Shared.colorPrimaryText)
                                                    .withAlpha(128)),
                                          ),
                                        ),
                                        //TO-DO make it dynamic
                                        minX: -1,
                                        maxX: 7,
                                        minY: 0,
                                        maxY: 8,
                                        titlesData: LineTitles.getTitleData(),
                                        lineBarsData: [
                                          LineChartBarData(
                                              spots: data.map((e) {
                                                return FlSpot(
                                                    e.pos, e.usageInHours / 3);
                                              }).toList(),
                                              dotData: FlDotData(getDotPainter:
                                                  (FlSpot spot,
                                                      double xPercentage,
                                                      LineChartBarData bar,
                                                      int index,
                                                      {double? size}) {
                                                return FlDotCirclePainter(
                                                  radius: size,
                                                  strokeWidth: 1.5,
                                                  color: Color(Shared
                                                      .colorSecondaryBackGround),
                                                  strokeColor: Color(
                                                      Shared.colorPrimaryText),
                                                );
                                              }),
                                              isCurved: true,
                                              belowBarData: BarAreaData(
                                                  show: true,
                                                  colors: [
                                                    Color(Shared
                                                            .colorPrimaryText)
                                                        .withOpacity(0.05)
                                                  ]),
                                              colors: [
                                                Color(Shared.colorPrimaryText)
                                              ])
                                        ])),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: Container(
                                  height: 160,
                                  child: Center(
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Color(
                                            Shared.colorSecondaryBackGround),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(Shared.colorPrimaryText)),
                                      ),
                                    ),
                                  ),
                                ));
                              }
                            } else {
                              return Center(
                                  child: Container(
                                height: 160,
                                child: Center(
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Color(
                                          Shared.colorSecondaryBackGround),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(Shared.colorPrimaryText)),
                                    ),
                                  ),
                                ),
                              ));
                            }
                          }),
                    ],
                  );
                }),
                Column(children: [
                  //General Data
                  //General Data
                  SizedBox(
                    height: 60,
                  ),
                  Divider(
                    color: Color(Shared.colorPrimaryText).withAlpha(128),
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  drawGenerals(
                      sharedInstance.dictionary[Shared.selectedLanguage]
                              ?["TODAY'S STATES"] ??
                          "",
                      Shared.getTodayCategory(),
                      Shared.getTodayTimeOn()),
                  SizedBox(
                    height: 20,
                  ),
                  drawGenerals(
                      sharedInstance.dictionary[Shared.selectedLanguage]
                              ?["AVERAGE THIS WEEK"] ??
                          "",
                      Shared.getAvarageThisWeekCategory(),
                      Shared.getAvarageThisWeekTimeOn(0),),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Color(Shared.colorPrimaryText).withAlpha(128),
                    thickness: 1,
                  ),
                ]),
                FutureBuilder(
                    future: _sharedData.getUsageStats(
                        dayFilter.subtract(Duration(days: 1)), dayFilter, true),
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
                          final data = snapshot.data as List<AppUsageInfo>;
                          int other = 100;
                          List<List<int>> appsData = [];
                          if (data.length != 0) {
                            for (var i = 1; i < 5; i++) {
                              other -= ((data[data.length - i].usage.inMinutes /
                                          _sharedData.totalUsage) *
                                      100)
                                  .round();
                            }
                            appsData = [
                              [
                                Shared.pieChartColor_blue,
                                ((data[data.length - 1].usage.inMinutes /
                                            _sharedData.totalUsage) *
                                        100)
                                    .round()
                              ],
                              [
                                Shared.pieChartColor_violet,
                                ((data[data.length - 2].usage.inMinutes /
                                            _sharedData.totalUsage) *
                                        100)
                                    .round()
                              ],
                              [
                                Shared.pieChartColor_red,
                                ((data[data.length - 3].usage.inMinutes /
                                            _sharedData.totalUsage) *
                                        100)
                                    .round()
                              ],
                              [
                                Shared.pieChartColor_yellow,
                                ((data[data.length - 4].usage.inMinutes /
                                            _sharedData.totalUsage) *
                                        100)
                                    .round()
                              ],
                              [Shared.pieChartColor_green, other]
                            ];
                          } else {
                            return SizedBox();
                          }
                          return Column(
                            children: [
                              //Pie-Chart
                              //Pie-Chart
                              //TO-DO : make it dynamic
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(PieChartData(
                                            sectionsSpace: 4,
                                            sections: appsData.map((e) {
                                              return PieChartSectionData(
                                                  radius: 35,
                                                  value: e[1].toDouble(),
                                                  titleStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                  title: e[1].toString() + "%",
                                                  color: Color(e[0]));
                                            }).toList())),
                                      )),

                                  //Indicators
                                  //Indicators
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(Shared
                                                      .pieChartColor_blue),
                                                ),
                                                FutureBuilder(
                                                    future: _sharedData.getIcon(
                                                        data[data.length - 1]
                                                            .packageName),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          Application app =
                                                              snapshot.data
                                                                  as Application;
                                                          return Text(
                                                            app.appName,
                                                            style: TextStyle(
                                                                color: Color(Shared
                                                                    .colorPrimaryText)),
                                                          );
                                                        } else {
                                                          return Text(
                                                              data[data.length -
                                                                      1]
                                                                  .appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        }
                                                      } else {
                                                        return Text(
                                                            data[data.length -
                                                                    1]
                                                                .appName,
                                                            style: TextStyle(
                                                                color: Color(Shared
                                                                    .colorPrimaryText)));
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(Shared
                                                      .pieChartColor_violet),
                                                ),
                                                FutureBuilder(
                                                    future: _sharedData.getIcon(
                                                        data[data.length - 2]
                                                            .packageName),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          Application app =
                                                              snapshot.data
                                                                  as Application;
                                                          return Text(
                                                              app.appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        } else {
                                                          return Text(
                                                              data[data.length -
                                                                      2]
                                                                  .appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        }
                                                      } else {
                                                        return Text(
                                                            data[data.length -
                                                                    2]
                                                                .appName,
                                                            style: TextStyle(
                                                                color: Color(Shared
                                                                    .colorPrimaryText)));
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(
                                                      Shared.pieChartColor_red),
                                                ),
                                                FutureBuilder(
                                                    future: _sharedData.getIcon(
                                                        data[data.length - 3]
                                                            .packageName),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          Application app =
                                                              snapshot.data
                                                                  as Application;
                                                          return Text(
                                                              app.appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        } else {
                                                          return Text(
                                                              data[data.length -
                                                                      3]
                                                                  .appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        }
                                                      } else {
                                                        return Text(
                                                            data[data.length -
                                                                    3]
                                                                .appName,
                                                            style: TextStyle(
                                                                color: Color(Shared
                                                                    .colorPrimaryText)));
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(Shared
                                                      .pieChartColor_yellow),
                                                ),
                                                FutureBuilder(
                                                    future: _sharedData.getIcon(
                                                        data[data.length - 4]
                                                            .packageName),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          Application app =
                                                              snapshot.data
                                                                  as Application;
                                                          return Text(
                                                              app.appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        } else {
                                                          return Text(
                                                              data[data.length -
                                                                      4]
                                                                  .appName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Shared
                                                                          .colorPrimaryText)));
                                                        }
                                                      } else {
                                                        return Text(
                                                            data[data.length -
                                                                    4]
                                                                .appName,
                                                            style: TextStyle(
                                                                color: Color(Shared
                                                                    .colorPrimaryText)));
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(Shared
                                                      .pieChartColor_green),
                                                ),
                                                Text(
                                                    sharedInstance.dictionary[Shared
                                                                .selectedLanguage]
                                                            ?["Other"] ??
                                                        "",
                                                    style: TextStyle(
                                                        color: Color(Shared
                                                            .colorPrimaryText)))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        } else
                          return Center(
                              child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: Container(
                                height: 45,
                                width: 45,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(Shared.colorPrimaryText)),
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
                              height: 45,
                              width: 45,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(Shared.colorPrimaryText)),
                              ),
                            ),
                          ),
                        ));
                    }),
              ],
            ),
          ),
        ));
  }

  Column drawGenerals(String title, Future<String?> futureCategory,
      Future<String?> futureTimeOn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Yu Gothic UI",
              color: Color(Shared.colorPrimaryText)),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(Shared.colorSecondaryBackGround)),
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/On_Off.svg"),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sharedInstance.dictionary[Shared.selectedLanguage]
                                  ?["Category"] ??
                              "",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorPrimaryText)),
                        ),
                        FutureBuilder(
                            future: futureCategory,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data as String,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Yu Gothic UI",
                                        color: Color(Shared.colorPrimaryText)),
                                  );
                                } else {
                                  return Center(
                                      child: Container(
                                    height: 15,
                                    child: Center(
                                      child: Container(
                                        width: 50,
                                        height: 6,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Shared.darkThemeOn
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Color(Shared.colorPrimaryText)),
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                              } else {
                                return Center(
                                    child: Container(
                                  height: 15,
                                  child: Center(
                                    child: Container(
                                      width: 50,
                                      height: 6,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Shared.darkThemeOn
                                            ? Colors.grey[700]
                                            : Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(Shared.colorPrimaryText)),
                                      ),
                                    ),
                                  ),
                                ));
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(Shared.colorSecondaryBackGround)),
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/Time.svg"),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sharedInstance.dictionary[Shared.selectedLanguage]
                                  ?["Total Usage"] ??
                              "",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorPrimaryText)),
                        ),
                        FutureBuilder(
                            future: futureTimeOn,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data as String,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Yu Gothic UI",
                                        color: Color(Shared.colorPrimaryText)),
                                  );
                                } else {
                                  return Center(
                                      child: Container(
                                    height: 15,
                                    child: Center(
                                      child: Container(
                                        width: 60,
                                        height: 6,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Shared.darkThemeOn
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Color(Shared.colorPrimaryText)),
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                              } else {
                                return Center(
                                    child: Container(
                                  height: 15,
                                  child: Center(
                                    child: Container(
                                      width: 60,
                                      height: 6,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Shared.darkThemeOn
                                            ? Colors.grey[700]
                                            : Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(Shared.colorPrimaryText)),
                                      ),
                                    ),
                                  ),
                                ));
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Expanded buildFilterButton(String text, int id) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilterId = id;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: AnimatedContainer(
            curve: Curves.decelerate,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: id == selectedFilterId ? Colors.white : Colors.transparent,
            ),
            duration: Duration(milliseconds: 300),
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                color: id == selectedFilterId
                    ? Color(Shared.colorPrimaryText)
                    : Colors.white,
              ),
            )),
          ),
        ),
      ),
      flex: 3,
    );
  }
}

class LineTitles {
  static getTitleData() {
    return FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            reservedSize: 10,
            rotateAngle: -45,
            showTitles: true,
            margin: 15,
            getTextStyles: (value) {
              return TextStyle(
                  color: Color(Shared.colorPrimaryText).withAlpha(160));
            },
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Monday"] ??
                      "";
                case 1:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Tuesday"] ??
                      "";
                case 2:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Wednesday"] ??
                      "";
                case 3:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Thursday"] ??
                      "";
                case 4:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Friday"] ??
                      "";
                case 5:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Saturday"] ??
                      "";
                case 6:
                  return SharedData().dictionary[Shared.selectedLanguage]
                          ?["Sunday"] ??
                      "";
                default:
                  return "";
              }
            }),
        leftTitles: SideTitles(
            reservedSize: 15,
            showTitles: true,
            margin: 10,
            getTextStyles: (value) {
              return TextStyle(
                  color: Color(Shared.colorPrimaryText).withAlpha(160));
            },
            getTitles: (value) {
              return (3 * value).toInt().toString() + "h";
            }));
  }
}
