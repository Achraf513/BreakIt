import 'dart:io';
import 'dart:math';

import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/Weekly.dart';
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
  DateTime startOfthisWeek = DateTime.now();
  DateFormat dateFormat = DateFormat("MM/dd");
  int selectedFilterId = 0;
  int totalAvarageUsage = 0;

  List<int> monthlyUsage = [];
  DateTime dayFilter = DateTime.now()
      .subtract(
          Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute))
      .add(Duration(days: 1));

  final _sharedData = SharedData();

  // ignore: must_call_super
  void initState() {
    DateTime now = DateTime.now();
    startOfthisWeek = startOfthisWeek
        .subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfthisWeek.weekday != DateTime.monday) {
      startOfthisWeek = startOfthisWeek.subtract(Duration(days: 1));
    }
  }

  Future<String> getAvarageThisWeekCategory() async{
    return "aa";
  }

  Future<String> getTodayCategory() async{
    return "bb";
  }

  Future<String> getAvarageThisWeekTimeOn() async{
    return "1h";
  }

  Future<String> getTodayTimeOn() async{
    return _sharedData.totalUsage.toString();
  }

  Future updateTodaysData() async{
    DateTime today = DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
    List<AppUsageInfo> infos = await _sharedData.getUsageStats(
      today,
      today.add(Duration(days: 1)),
      false
    );
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

    WeeklyInfo? todaysWeeklyInfo = await DataBase.instance.getTodaysWeeklyInfo();

    if(todaysWeeklyInfo!=null)
    {
      WeeklyInfo weeklyInfo = WeeklyInfo(
        id: todaysWeeklyInfo.id,
        idWeek: startOfthisWeek.day.toString() +
            startOfthisWeek.month.toString() +
            startOfthisWeek.add(Duration(days: 6)).day.toString() +
            startOfthisWeek.add(Duration(days: 6)).month.toString() +
            startOfthisWeek.year.toString(),
        idDay: today.year.toString() +
            today.month.toString() +
            today.day.toString(),
        dayUsage: totalUsageLocal,
        pos: today.difference(startOfthisWeek).inDays.toDouble(),
        mainCategory: "Unknown"
      );
      DataBase.instance.updateWeeklyInfo(weeklyInfo);
    }
  }

  Future<List<WeeklyInfo>> getWeeklyUsage() async {
    List<List<double>> weeklyUsage = [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0],
      [4, 0],
      [5, 0],
      [6, 0]
    ];
    String idWeek = startOfthisWeek.day.toString() +
        startOfthisWeek.month.toString() +
        startOfthisWeek.add(Duration(days: 6)).day.toString() +
        startOfthisWeek.add(Duration(days: 6)).month.toString() +
        startOfthisWeek.year.toString();
    
    List<WeeklyInfo>? result = await DataBase.instance.readWeeklyInfo(idWeek);
    if (result != null) {
      Generaldata? lastCheck = await DataBase.instance.getLastCheckDashBoard();
      if(lastCheck!=null){
        if(DateTime.now().subtract(Duration(minutes: 10)).isAfter(DateTime.parse(lastCheck.data))){
          await updateTodaysData();
          await DataBase.instance.updateLastCheckDashBoard();
        } 
      }
      result = await DataBase.instance.readWeeklyInfo(idWeek);
      if (result != null) {
        return result;
      } else return [];
    } else {
      result = [];
      for (var i = 0; i < 7; i++) {
        List<AppUsageInfo> infos = await _sharedData.getUsageStats(
            startOfthisWeek.add(Duration(days: i)),
            startOfthisWeek.add(Duration(days: i + 1)),
            false);
        int totalUsageLocal = 0;
        for (var app in infos) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          if (moreDetails != null) {
            if (!moreDetails.systemApp) {
              totalUsageLocal += app.usage.inMinutes;
            }
          }
        }
        weeklyUsage[i][1] = totalUsageLocal / 60 < 14
            ? totalUsageLocal / 60
            : 2 + Random().nextDouble() * 10;

        WeeklyInfo weeklyInfo = WeeklyInfo(
            idWeek: startOfthisWeek.day.toString() +
                startOfthisWeek.month.toString() +
                startOfthisWeek.add(Duration(days: 6)).day.toString() +
                startOfthisWeek.add(Duration(days: 6)).month.toString() +
                startOfthisWeek.year.toString(),
            idDay: startOfthisWeek.add(Duration(days: i)).year.toString() +
                startOfthisWeek.add(Duration(days: i)).month.toString() +
                startOfthisWeek.add(Duration(days: i)).day.toString(),
            dayUsage: weeklyUsage[i][1],
            pos: weeklyUsage[i][0],
            mainCategory: "Unknown");
        if(infos.length!=0){
          DataBase.instance.createWeeklyInfo(weeklyInfo);
          result.add(weeklyInfo);
        }
      }
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Color(Shared.color_primaryGrey)),
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
                              startOfthisWeek =
                                  startOfthisWeek.subtract(Duration(days: 6));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Color(Shared.color_primaryViolet)),
                        ),
                      ),
                      Expanded(
                          flex: 8,
                          child: Center(
                              child: Text(
                            dateFormat.format(startOfthisWeek) +
                                " - " +
                                dateFormat.format(
                                    startOfthisWeek.add(Duration(days: 6))) +
                                " : " +
                                startOfthisWeek.year.toString(),
                            style: TextStyle(
                                color: Color(Shared.color_primaryViolet)),
                          ))),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              startOfthisWeek =
                                  startOfthisWeek.add(Duration(days: 6));
                            });
                          },
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              color: Color(Shared.color_primaryViolet)),
                        ),
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
                      if(data.length == 0){
                        return Center(
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  "Click refresh once you granted permession",
                                  style: TextStyle(
                                      color: Color(Shared.color_primaryViolet),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color(Shared.color_primaryViolet),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: 180,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "refresh",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
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
                                      color: Color(Shared.color_secondaryGrey),
                                      strokeWidth: 0.25);
                                },
                              ), //2mk6RpQJ
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                      width: 0.25,
                                      color: Color(Shared.color_secondaryGrey)),
                                  top: BorderSide(
                                      width: 0.25,
                                      color: Color(Shared.color_secondaryGrey)),
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
                                      return FlSpot(e.pos, e.dayUsage / 3);
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
                                            Color(Shared.color_primaryViolet),
                                      );
                                    }),
                                    isCurved: true,
                                    belowBarData: BarAreaData(
                                        show: true,
                                        colors: [
                                          Color(Shared.color_primaryViolet)
                                              .withOpacity(0.05)
                                        ]),
                                    colors: [Color(Shared.color_primaryViolet)])
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
                                  Color(Shared.color_primaryViolet)),
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
                                Color(Shared.color_primaryViolet)),
                          ),
                        ),
                      ),
                    ));
                  }
                }),
          Column(
            children: [
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
                "TODAY'S STATES",
                getTodayCategory(),
                getTodayTimeOn()
              ),
              SizedBox(
                height: 20,
              ),
              drawGenerals(
                "AVERAGE THIS WEEK",
                getAvarageThisWeekCategory(),
                getAvarageThisWeekTimeOn()
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
              ),]
            ),
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
                      return Column(children: [ 
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
                                                          "Loading ...");
                                                    }
                                                  } else {
                                                    return Text("Loading ...");
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
                                                          "Loading ...");
                                                    }
                                                  } else {
                                                    return Text("Loading ...");
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
                                                          "Loading ...");
                                                    }
                                                  } else {
                                                    return Text("Loading ...");
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
                                                          "Loading ...");
                                                    }
                                                  } else {
                                                    return Text("Loading ...");
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
                                            Text("Other")
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
                                  Color(Shared.color_primaryViolet)),
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
                                Color(Shared.color_primaryViolet)),
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

  Column drawGenerals(String title, Future<String> futureCategory, Future<String> futureTimeOn) {
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
              color: Color(Shared.color_primaryViolet)),
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
                    color: Color(Shared.color_primaryGrey)),
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
                          "Category",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.color_primaryViolet)),
                        ),
                        FutureBuilder(
                          future: futureCategory,
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              if(snapshot.hasData){
                                return Text(
                                  snapshot.data as String,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Yu Gothic UI",
                                      color: Color(Shared.color_secondaryGrey)),
                                );
                              } else{
                                return Center(
                                  child: Container(
                                    height: 25,
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Color(Shared.color_primaryViolet)),
                                        ),
                                      ),
                                    ),
                                  )
                                );
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
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(Shared.color_primaryViolet)),
                                      ),
                                    ),
                                  ),
                                )
                              );
                            }
                          }
                        ),
                        
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
                    color: Color(Shared.color_primaryGrey)),
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
                          "Total Usage",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.color_primaryViolet)),
                        ),
                        FutureBuilder(
                          future: futureTimeOn,
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              if(snapshot.hasData){
                                return Text(
                                  snapshot.data as String,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Yu Gothic UI",
                                      color: Color(Shared.color_secondaryGrey)),
                                );
                              } else{
                                return Center(
                                  child: Container(
                                    height: 25,
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Color(Shared.color_primaryViolet)),
                                        ),
                                      ),
                                    ),
                                  )
                                );
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
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(Shared.color_primaryViolet)),
                                      ),
                                    ),
                                  ),
                                )
                              );
                            }
                          }
                        ),
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
                    ? Color(Shared.color_primaryViolet)
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
                  return "Monday";
                case 1:
                  return "Tuesday";
                case 2:
                  return "Wednesday";
                case 3:
                  return "Thursday";
                case 4:
                  return "Friday";
                case 5:
                  return "Saturday";
                case 6:
                  return "Sunday";
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
