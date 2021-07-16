import 'package:break_it/Shared.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedFilterId = 0;
  DateTime dayFilter= DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute)).add(Duration(days: 1));
  List<List<int>> appsData = [
    [Shared.pieChartColor_blue, 38],
    [Shared.pieChartColor_green, 17],
    [Shared.pieChartColor_red, 12],
    [Shared.pieChartColor_yellow, 33]
  ];
  final _sharedData = SharedData();

  @override
  Widget build(BuildContext context) {
    _sharedData.totalUsage = 0;
    return Scaffold(
        body: FutureBuilder(
            future: _sharedData.getUsageStats(
                dayFilter.subtract(Duration(days: 1)), dayFilter),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Button-Controller
                      // Button-Controller
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(Shared.color_primaryViolet)),
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildFilterButton("Daily", 0),
                            buildFilterButton("Weekly", 1),
                            buildFilterButton("Monthly", 2),
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
                              color: Color(Shared.color_primaryGrey)),
                          width: double.infinity,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.arrow_back_ios_new_rounded,
                                      color: Color(Shared.color_primaryViolet)),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Center(
                                        child: Text(
                                      "04-10 July 2021",
                                      style: TextStyle(
                                          color: Color(
                                              Shared.color_primaryViolet)),
                                    ))),
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: Color(Shared.color_primaryViolet)),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 50,
                      ),

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
                                ),
                              ),
                              //TO-DO make it dynamic
                              minX: -1,
                              maxX: 7,
                              minY: 2,
                              maxY: 5,
                              titlesData: LineTitles.getTitleData(),
                              lineBarsData: [
                                LineChartBarData(
                                    spots: [
                                      //TO-DO make it dynamic
                                      FlSpot(0, 3),
                                      FlSpot(1, 4),
                                      FlSpot(2, 4.5),
                                      FlSpot(3, 3.8),
                                      FlSpot(4, 3.5),
                                      FlSpot(5, 4),
                                      FlSpot(6, 2.5),
                                    ],
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
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(PieChartData(
                                    sectionsSpace: 4,
                                    sections: appsData.sublist(0, 4).map((e) {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          height: 15,
                                          width: 15,
                                          color:
                                              Color(Shared.pieChartColor_blue),
                                        ),
                                        Text("Facebook")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          height: 15,
                                          width: 15,
                                          color:
                                              Color(Shared.pieChartColor_green),
                                        ),
                                        Text("Instagrame")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          height: 15,
                                          width: 15,
                                          color:
                                              Color(Shared.pieChartColor_red),
                                        ),
                                        Text("Youtube")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          height: 15,
                                          width: 15,
                                          color: Color(
                                              Shared.pieChartColor_yellow),
                                        ),
                                        Text("Google chrome")
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
                  ),
                ),
              );
            }));
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
                          "Screen unlocked",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.color_primaryViolet)),
                        ),
                        Text(
                          timesUnlocked,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.color_secondaryGrey)),
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
                        Text(
                          timeOn,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Yu Gothic UI",
                              color: Color(Shared.color_secondaryGrey)),
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
              return value.toInt().toString() + "h";
            }));
  }
}
