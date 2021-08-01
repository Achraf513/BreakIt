import 'dart:io';
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
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static DateTime startOfTheWeek = DateTime.now();
  DateFormat dateFormat = DateFormat("MM/dd");
  int selectedFilterId = 0;
  int totalAvarageUsage = 0;
  static SharedData sharedInstance = SharedData();

  List<int> monthlyUsage = [];
  DateTime dayFilter = DateTime.now()
      .subtract(
          Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute))
      .add(Duration(days: 1));

  static final _sharedData = SharedData();

  // ignore: must_call_super
  void initState() {
    DateTime now = DateTime.now();
    startOfTheWeek =
        startOfTheWeek.subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfTheWeek.weekday != DateTime.monday) {
      startOfTheWeek = startOfTheWeek.subtract(Duration(days: 1));
    }
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

  Future<String?> getAvarageThisWeekCategory() async {
    String test = await DataBase.instance.getThisWeeksCategory()??"";
    return sharedInstance.dictionary[Shared.selectedLanguage]?[test];
  }

  Future<String?> getTodayCategory() async {
    String test = await DataBase.instance.getTodaysDailyCategory()??"";
    return sharedInstance.dictionary[Shared.selectedLanguage]?[test];
  }

  Future<String> getAvarageThisWeekTimeOn() async {
    DateTime now = DateTime.now();
    DateTime startOfthisWeek =
        now.subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfthisWeek.weekday != DateTime.monday) {
      startOfthisWeek = startOfthisWeek.subtract(Duration(days: 1));
    }
    //This.idWeek = ThisWeeksLastDay.substract(Duratuin(hours : 24))
    String idWeek = startOfthisWeek.day.toString() +
        startOfthisWeek.month.toString() +
        startOfthisWeek.add(Duration(days: 6)).day.toString() +
        startOfthisWeek.add(Duration(days: 6)).month.toString() +
        startOfthisWeek.year.toString();

    List<WeeklyInfo>? result = await DataBase.instance.readWeeklyInfo(idWeek);
    if (result != null) {
      if (result.last.pos ==
          DateTime.now().difference(startOfthisWeek).inDays) {
        int totalUsage = 0;
        for (var weeklyInfo in result) {
          int usage = (weeklyInfo.usageInHours * 60).toInt();
          totalUsage += usage;
        }
        totalUsage = totalUsage ~/ result.length;
        int totalHours = (totalUsage ~/ 60);
        int totalMinutes = totalUsage - (totalUsage ~/ 60) * 60;
        String hoursText = totalHours != 0 ? totalHours.toString() + "h" : "";
        String minutesText =
            totalMinutes != 0 ? totalMinutes.toString() + "min" : "";
        return hoursText + minutesText;
      } else {
        Future.delayed(Duration(seconds: 3));
        return getAvarageThisWeekTimeOn();
      }
    } else {
      Future.delayed(Duration(seconds: 3));
      return getAvarageThisWeekTimeOn();
    }
  }

  Future<String> getTodayTimeOn() async {
    WeeklyInfo? todaysWeeklyInfo =
        await DataBase.instance.getTodaysWeeklyInfo();
    if (todaysWeeklyInfo != null) {
      int usage = (todaysWeeklyInfo.usageInHours * 60).toInt();
      int hours = usage ~/ 60;
      int minutes = usage - (usage ~/ 60) * 60;
      String hoursText = hours != 0 ? hours.toString() + "h" : "";
      String minutesText = minutes != 0 ? minutes.toString() + "min" : "";
      return hoursText + minutesText;
    } else {
      Future.delayed(Duration(seconds: 3));
      return getTodayTimeOn();
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
      Generaldata? lastCheck = await DataBase.instance.getLastCheckDashBoard();
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
            : 2 + Random().nextDouble() * 10;

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

  @override
  Widget build(BuildContext context) {
    String idWeek = startOfTheWeek.day.toString() +
        startOfTheWeek.month.toString() +
        startOfTheWeek.add(Duration(days: 6)).day.toString() +
        startOfTheWeek.add(Duration(days: 6)).month.toString() +
        startOfTheWeek.year.toString();
    print(idWeek);
    DateTime now = DateTime.now();
    DateTime startOfThisWeek =
        now.subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfThisWeek.weekday != DateTime.monday) {
      startOfThisWeek = startOfThisWeek.subtract(Duration(days: 1));
    }
    String idThisWeek = startOfThisWeek.day.toString() +
        startOfThisWeek.month.toString() +
        startOfThisWeek.add(Duration(days: 6)).day.toString() +
        startOfThisWeek.add(Duration(days: 6)).month.toString() +
        startOfThisWeek.year.toString();

    _sharedData.totalUsage = 0;
    return Scaffold(
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
            Container(
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
                          onTap: () {
                            setState(() {
                              startOfTheWeek =
                                  startOfTheWeek.subtract(Duration(days: 7));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Color(Shared.color_primary1)),
                        ),
                      ),
                      Expanded(
                          flex: 8,
                          child: Center(
                              child: Text(
                            dateFormat.format(startOfTheWeek) +
                                " - " +
                                dateFormat.format(
                                    startOfTheWeek.add(Duration(days: 6))) +
                                " : " +
                                startOfTheWeek.year.toString(),
                            style:
                                TextStyle(color: Color(Shared.color_primary1)),
                          ))),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              if (idThisWeek != idWeek) {
                                setState(() {
                                  startOfTheWeek =
                                      startOfTheWeek.add(Duration(days: 7));
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: idThisWeek != idWeek
                                  ? Color(Shared.color_primary1)
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
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data as List<WeeklyInfo>;
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
                                      color: Color(Shared.color_secondary2),
                                      strokeWidth: 0.25);
                                },
                              ), //2mk6RpQJ
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                      width: 0.25,
                                      color: Color(Shared.color_secondary2)),
                                  top: BorderSide(
                                      width: 0.25,
                                      color: Color(Shared.color_secondary2)),
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
                                      return FlSpot(e.pos, e.usageInHours / 3);
                                    }).toList(),
                                    dotData: FlDotData(getDotPainter:
                                        (FlSpot spot, double xPercentage,
                                            LineChartBarData bar, int index,
                                            {double? size}) {
                                      return FlDotCirclePainter(
                                        radius: size,
                                        strokeWidth: 1.5,
                                        color: Colors.white,
                                        strokeColor:
                                            Color(Shared.color_primary1),
                                      );
                                    }),
                                    isCurved: true,
                                    belowBarData: BarAreaData(
                                        show: true,
                                        colors: [
                                          Color(Shared.color_primary1)
                                              .withOpacity(0.05)
                                        ]),
                                    colors: [Color(Shared.color_primary1)])
                              ])),
                        ),
                      );
                    } else {
                      return Center(
                          child: Container(
                        height: 160,
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(Shared.color_primary1)),
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
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(Shared.color_primary1)),
                          ),
                        ),
                      ),
                    ));
                  }
                }),
            Column(children: [
              //General Data
              //General Data
              SizedBox(
                height: 60,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 20,
              ),
              drawGenerals(
                  sharedInstance.dictionary[Shared.selectedLanguage]
                          ?["TODAY'S STATES"] ??
                      "",
                  getTodayCategory(),
                  getTodayTimeOn()),
              SizedBox(
                height: 20,
              ),
              drawGenerals(
                  sharedInstance.dictionary[Shared.selectedLanguage]
                          ?["AVERAGE THIS WEEK"] ??
                      "",
                  getAvarageThisWeekCategory(),
                  getAvarageThisWeekTimeOn()),
              SizedBox(
                height: 20,
              ),
              Divider(
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
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
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
                                              color: Color(
                                                  Shared.pieChartColor_blue),
                                            ),
                                            FutureBuilder(
                                                future: _sharedData.getIcon(
                                                    data[data.length - 1]
                                                        .packageName),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      Application app = snapshot
                                                          .data as Application;
                                                      return Text(app.appName);
                                                    } else {
                                                      return Text(
                                                          data[data.length - 1]
                                                              .appName);
                                                    }
                                                  } else {
                                                    return Text(
                                                        data[data.length - 1]
                                                            .appName);
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
                                                  Shared.pieChartColor_violet),
                                            ),
                                            FutureBuilder(
                                                future: _sharedData.getIcon(
                                                    data[data.length - 2]
                                                        .packageName),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      Application app = snapshot
                                                          .data as Application;
                                                      return Text(app.appName);
                                                    } else {
                                                      return Text(
                                                          data[data.length - 2]
                                                              .appName);
                                                    }
                                                  } else {
                                                    return Text(
                                                        data[data.length - 2]
                                                            .appName);
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
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      Application app = snapshot
                                                          .data as Application;
                                                      return Text(app.appName);
                                                    } else {
                                                      return Text(
                                                          data[data.length - 3]
                                                              .appName);
                                                    }
                                                  } else {
                                                    return Text(
                                                        data[data.length - 3]
                                                            .appName);
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
                                                  Shared.pieChartColor_yellow),
                                            ),
                                            FutureBuilder(
                                                future: _sharedData.getIcon(
                                                    data[data.length - 4]
                                                        .packageName),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      Application app = snapshot
                                                          .data as Application;
                                                      return Text(app.appName);
                                                    } else {
                                                      return Text(
                                                          data[data.length - 4]
                                                              .appName);
                                                    }
                                                  } else {
                                                    return Text(
                                                        data[data.length - 4]
                                                            .appName);
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
                                                  Shared.pieChartColor_green),
                                            ),
                                            Text(sharedInstance.dictionary[
                                                        Shared.selectedLanguage]
                                                    ?["Other"] ??
                                                "")
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
              color: Color(Shared.color_primary1)),
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
                    color: Color(Shared.color_primary2)),
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
                              color: Color(Shared.color_primary1)),
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
                                        color: Color(Shared.color_secondary2)),
                                  );
                                } else {
                                  return Center(
                                      child: Container(
                                    height: 25,
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(Shared.color_primary1)),
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                              } else {
                                return Center(
                                    child: Container(
                                  height: 25,
                                  child: Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(Shared.color_primary1)),
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
                    color: Color(Shared.color_primary2)),
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
                              color: Color(Shared.color_primary1)),
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
                                        color: Color(Shared.color_secondary2)),
                                  );
                                } else {
                                  return Center(
                                      child: Container(
                                    height: 25,
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(Shared.color_primary1)),
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                              } else {
                                return Center(
                                    child: Container(
                                  height: 25,
                                  child: Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(Shared.color_primary1)),
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
                    ? Color(Shared.color_primary1)
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
            getTitles: (value) {
              return (3 * value).toInt().toString() + "h";
            }));
  }
}
