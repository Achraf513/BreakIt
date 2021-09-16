import 'package:app_usage/app_usage.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime startOfthisWeek = DateTime.now();
  int selectedFilterId = 0;
  int totalAvarageUsage = 0;
  List<List<double>> weeklyUsage = [[0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0]];
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
    getWeeklyUsage();
  }

  void getWeeklyUsage() async {
    for (var i = 0; i < 7; i++) {
      List<AppUsageInfo> infos = await _sharedData.getUsageStats(
          startOfthisWeek.add(Duration(days: i)),
          startOfthisWeek.add(Duration(days: i + 1)),
          false);
      int totalUsage_ = 0;
      for (var app in infos) {
        Application? moreDetails = await DeviceApps.getApp(app.packageName);
        if (moreDetails != null) {
          if (!moreDetails.systemApp) {
            totalUsage_ += app.usage.inMinutes;
          }
        }
      }
      weeklyUsage[i][1] = totalUsage_ / 60;
    }
    setState(() {
      print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    _sharedData.totalUsage = 0;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Button-Controller
            // Button-Controller
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(Shared.colorPrimaryText)),
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

            // Date Filter-Controller
            // Date Filter-Controller
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(Shared.colorSecondary2BackGround)),
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(Shared.colorPrimaryText)),
                      ),
                      Expanded(
                          flex: 8,
                          child: Center(
                              child: Text(
                            "04-10 July 2021",
                            style: TextStyle(
                                color: Color(Shared.colorPrimaryText)),
                          ))),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(Shared.colorPrimaryText)),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 50,
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
                      for (var i = 1; i < 5; i++) {
                        other -= ((data[data.length - i].usage.inMinutes /
                                    _sharedData.totalUsage) *
                                100)
                            .round();
                      }
                      List<List<int>> appsData = [
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
                      return Column(
                        children: [
                          // Line Chart
                          // Line Chart
                          Container(
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
                                          color:
                                              Color(Shared.colorSecondaryBackGround),
                                          strokeWidth: 0.25);
                                    },
                                  ), //2mk6RpQJ
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.25,
                                          color: Color(
                                              Shared.colorSecondaryBackGround)),
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
                                        spots: weeklyUsage.map((e){
                                          if(e[1]!=0){
                                          }
                                          return FlSpot(e[0], e[1]/3);
                                        }).toList(),
                                        dotData: FlDotData(getDotPainter:
                                            (FlSpot spot, double xPercentage,
                                                LineChartBarData bar, int index,
                                                {double? size}) {
                                          return FlDotCirclePainter(
                                            radius: size,
                                            strokeWidth: 1.5,
                                            color: Colors.white,
                                            strokeColor: Color(
                                                Shared.colorPrimaryText),
                                          );
                                        }),
                                        isCurved: true,
                                        belowBarData: BarAreaData(
                                            show: true,
                                            colors: [
                                              Color(Shared.colorPrimaryText)
                                                  .withOpacity(0.05)
                                            ]),
                                        colors: [
                                          Color(Shared.colorPrimaryText)
                                        ])
                                  ])),
                            ),
                          ),

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
                              "TODAY",
                              "35 Times",
                              (_sharedData.totalUsage ~/ 60) != 0
                                  ? (_sharedData.totalUsage ~/ 60).toString() +
                                      "h" +
                                      ((_sharedData.totalUsage % 60) != 0
                                          ? (_sharedData.totalUsage % 60)
                                                  .toString() +
                                              "min"
                                          : "")
                                  : (_sharedData.totalUsage % 60).toString() +
                                      "min"),
                          SizedBox(
                            height: 20,
                          ),
                          drawGenerals("AVERAGE", "42 Times", "5h 43min"),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 1,
                          ),

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
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width / 3,
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

  Column drawGenerals(String title, String timesUnlocked, String timeOn) {
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
                          "Screen unlocked",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorPrimaryText)),
                        ),
                        Text(
                          timesUnlocked,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorPrimaryText)),
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
                          "Total Usage",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorPrimaryText)),
                        ),
                        Text(
                          timeOn,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.colorSecondary2BackGround)),
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
              return (3*value).toInt().toString() + "h";
            }));
  }
}
