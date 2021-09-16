import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/RuleModel.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AddNewRule extends StatefulWidget {
  const AddNewRule({Key? key}) : super(key: key);

  @override
  _AddNewRuleState createState() => _AddNewRuleState();
}

class _AddNewRuleState extends State<AddNewRule> {
  AppUsageInfo appSelected = SharedData().applications.last;
  String notificationFrequency =
      SharedData().dictionary[Shared.selectedLanguage]?["Once daily"] ??
          "Once daily";
  String hoursSelected = "1 " +
      (SharedData().dictionary[Shared.selectedLanguage]?["Hour"] ?? "Hour");
  String minutesSelected = "15 Min";
  // ignore: must_call_super
  void initState() {}

  Future<Application?> getAppData(String packageName) async {
    Future<Application?> app = DeviceApps.getApp(packageName, true);
    return app;
  }

  @override
  Widget build(BuildContext context) {
    var hours = [
      "0 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "1 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hour"] ?? "Hour"),
      "2 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "3 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "4 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "5 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "6 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "7 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "8 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "9 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "10 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "11 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours"),
      "12 " +
          (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
              "Hours")
    ];

    var minutes = [
      "0 Min",
      "5 Min",
      "10 Min",
      "15 Min",
      "20 Min",
      "25 Min",
      "30 Min",
      "35 Min",
      "40 Min",
      "45 Min",
      "50 Min",
      "55 Min"
    ];

    var notificationFrequencies = [
      SharedData().dictionary[Shared.selectedLanguage]?["Once daily"] ??
          "Once daily",
      SharedData().dictionary[Shared.selectedLanguage]?["Twice daily"] ??
          "Twice daily",
      SharedData().dictionary[Shared.selectedLanguage]?["3 times a day"] ??
          "3 times a day",
      SharedData().dictionary[Shared.selectedLanguage]?["4 times a day"] ??
          "4 times a day",
      SharedData().dictionary[Shared.selectedLanguage]?["5 times a day"] ??
          "5 times a day",
    ];

    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.colorUi),
        title: Text(
          SharedData().dictionary[Shared.selectedLanguage]?["New Rule"] ??
              "New Rule",
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
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(Shared.colorSecondaryBackGround),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SharedData().dictionary[Shared.selectedLanguage]
                              ?["Application"] ??
                          "Application",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(Shared.colorPrimaryText),
                      ),
                    ),
                    SizedBox(height: 10),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 50,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(Shared.colorPrimaryBackGround),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(Shared.colorPrimaryBackGround),
                                width: 0.5)),
                        child: DropdownButton(
                          dropdownColor: Color(Shared.colorSecondaryBackGround),
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                            color:
                                Color(Shared.colorPrimaryText).withAlpha(128),
                          ),
                          value: appSelected,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: SharedData()
                              .applications
                              .reversed
                              .map((AppUsageInfo items) {
                            return DropdownMenuItem(
                                value: items,
                                child: FutureBuilder(
                                    future: getAppData(items.packageName),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          Application data =
                                              snapshot.data as Application;
                                          return Row(
                                            children: [
                                              data is ApplicationWithIcon
                                                  ? Container(
                                                      width: 25,
                                                      height: 25,
                                                      child: Image.memory(
                                                          data.icon))
                                                  : SizedBox(),
                                              SizedBox(width: 10),
                                              Text(data.appName),
                                            ],
                                          );
                                        }
                                      }
                                      return Text(items.appName);
                                    }));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              appSelected = newValue as AppUsageInfo;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(Shared.colorSecondaryBackGround),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SharedData().dictionary[Shared.selectedLanguage]
                              ?["Usage Limit"] ??
                          "Usage Limit",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(Shared.colorPrimaryText)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Expanded(
                            flex: 5,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(Shared.colorPrimaryBackGround),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color(Shared.colorPrimaryBackGround),
                                      width: 0.5)),
                              child: DropdownButton(
                                dropdownColor:
                                    Color(Shared.colorSecondaryBackGround),
                                isExpanded: true,
                                underline: SizedBox(),
                                style: TextStyle(
                                    color: Color(Shared.colorPrimaryText)
                                        .withAlpha(160)),
                                value: hoursSelected,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: hours.map((String hours) {
                                  return DropdownMenuItem(
                                      value: hours, child: Text(hours));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    hoursSelected = newValue.toString();
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          width: 5,
                        ),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Expanded(
                            flex: 5,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(Shared.colorPrimaryBackGround),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color(Shared.colorPrimaryBackGround),
                                      width: 0.5)),
                              child: DropdownButton(
                                isExpanded: true,
                                dropdownColor:
                                    Color(Shared.colorSecondaryBackGround),
                                underline: SizedBox(),
                                style: TextStyle(
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(160),
                                ),
                                value: minutesSelected,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: minutes.map((String minutes) {
                                  return DropdownMenuItem(
                                      value: minutes,
                                      child: Text(minutes,
                                          style: TextStyle(
                                            color:
                                                Color(Shared.colorPrimaryText)
                                                    .withAlpha(160),
                                          )));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    minutesSelected = newValue.toString();
                                  });
                                },
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(Shared.colorSecondaryBackGround),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SharedData().dictionary[Shared.selectedLanguage]
                              ?["Notification Frequency"] ??
                          "Notification Frequency",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(Shared.colorPrimaryText)),
                    ),
                    SizedBox(height: 10),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 50,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(Shared.colorPrimaryBackGround),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Color(Shared.colorPrimaryBackGround),
                                width: 0.5)),
                        child: DropdownButton(
                          dropdownColor: Color(Shared.colorSecondaryBackGround),
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                              color: Color(Shared.colorPrimaryText)
                                  .withAlpha(128)),
                          value: notificationFrequency,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: notificationFrequencies.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              notificationFrequency = newValue.toString();
                            });
                          },
                        ),
                      );
                    })
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: Text(
                      SharedData().dictionary[Shared.selectedLanguage]
                              ?["Cancel"] ??
                          "Cancel",
                      style: TextStyle(
                          color: Color(Shared.colorPrimaryBackGround)),
                    )),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () async {
                    DateTime day = DateTime.now();
                    String todaysId = day.year.toString() +
                        day.month.toString() +
                        day.day.toString();
                    RuleModel ruleModel = RuleModel(
                        appName: appSelected.appName,
                        appPackageName: appSelected.packageName,
                        usageLimitInH: int.parse(hoursSelected.substring(0, 2)),
                        usageLimitInMin:
                            int.parse(minutesSelected.substring(0, 2)),
                        notificationFrequency: notificationFrequencies
                                .indexOf(notificationFrequency) +
                            1,
                        todaysNotifications: notificationFrequencies
                                .indexOf(notificationFrequency) +
                            1,
                        lastDaysNotificationId: todaysId);
                    RuleModel? ruleResulted =
                        (await DataBase.instance.getRuleId(ruleModel));
                    if (ruleResulted == null) {
                      await DataBase.instance.createRule(ruleModel);
                    } else {
                      await DataBase.instance
                          .updateRule(ruleModel.copy(id: ruleResulted.id));
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(Shared.colorUi),
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: Text(
                      SharedData().dictionary[Shared.selectedLanguage]
                              ?["Submit"] ??
                          "Submit",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
