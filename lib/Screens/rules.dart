import 'package:break_it/Models/RuleModel.dart';
import 'package:break_it/Screens/addNewRule.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  void parentSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Shared.blockUser = false;
    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(Shared.colorSecondary2BackGround),
        child: Icon(Icons.add),
        onPressed: () async {
          await SharedData().getAppList();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewRule()),
          ).then((value) {
            setState(() {});
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FutureBuilder(
              future: DataBase.instance.readRules(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<RuleModel> rules = snapshot.data as List<RuleModel>;
                    if (rules.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                SharedData().dictionary[Shared.selectedLanguage]
                                        ?[
                                        "Welcome to BreakIt Rules Functionality"] ??
                                    "Welcome to BreakIt Rules Functionality",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(Shared.colorPrimaryText),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                SharedData().dictionary[Shared.selectedLanguage]
                                        ?[
                                        "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'."] ??
                                    "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(Shared.colorPrimaryText),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    DateTime day = DateTime.now();
                    String todaysId = day.year.toString() +
                        day.month.toString() +
                        day.day.toString();
                    if (rules.first.lastDaysNotificationId != todaysId) {
                      for (var rule in rules) {
                        DataBase.instance.updateRule(
                            rule.copy(lastDaysNotificationId: todaysId));
                      }
                    }
                    return Column(
                        children: rules
                            .map((rule) => RuleWidget(
                                ruleModel: rule, callback: this.parentSetState))
                            .toList());
                  }
                  return Center(child: Text("Loading ..."));
                }
                return Center(child: Text("Loading ..."));
              },
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class RuleWidget extends StatefulWidget {
  RuleModel ruleModel;
  Function callback;
  RuleWidget({required this.ruleModel, required this.callback});

  @override
  _RuleWidgetState createState() => _RuleWidgetState(rule: ruleModel);
}

class _RuleWidgetState extends State<RuleWidget> {
  RuleModel rule;
  _RuleWidgetState({required this.rule});

  void initState() {
    super.initState();
    Shared.blockUser = false;
  }

  Future<Application?> getAppData(String packageName) async {
    Future<Application?> app = DeviceApps.getApp(packageName, true);
    return app;
  }

  String? getCategory(ApplicationCategory appCategory, bool isSysApp) {
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
        return SharedData().dictionary[Shared.selectedLanguage]?["Navigation"];
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

  Future<void> _showMyDialog() async {
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

    String notificationFrequency =
        notificationFrequencies[rule.notificationFrequency - 1];
    String hoursSelected = rule.usageLimitInH == 1
        ? rule.usageLimitInH.toString() +
            " " +
            (SharedData().dictionary[Shared.selectedLanguage]?["Hour"] ??
                "Hour")
        : rule.usageLimitInH.toString() +
            " " +
            (SharedData().dictionary[Shared.selectedLanguage]?["Hours"] ??
                "Hours");

    String minutesSelected = rule.usageLimitInMin.toString() + " " + "Min";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Color(Shared.colorPrimaryBackGround),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 9,
                    child: Text(
                        SharedData().dictionary[Shared.selectedLanguage]
                                ?["Edit rule"] ??
                            "Edit rule",
                        style:
                            TextStyle(color: Color(Shared.colorPrimaryText)))),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_outlined,
                        color: Color(Shared.colorPrimaryText),
                      )),
                )
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FutureBuilder(
                    future: getAppData(rule.appPackageName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          Shared.blockUser = false;
                          Application appSecondaryData =
                              snapshot.data as Application;
                          return Row(
                            children: [
                              Container(
                                  height: 40,
                                  width: 40,
                                  child: appSecondaryData is ApplicationWithIcon
                                      ? Image.memory(appSecondaryData.icon)
                                      : Icon(Icons.android_rounded)),
                              SizedBox(
                                width: 10,
                              ),
                              Text(appSecondaryData.appName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(Shared.colorPrimaryText))),
                            ],
                          );
                        }
                      }
                      return Text(rule.appName);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SharedData().dictionary[Shared.selectedLanguage]
                                ?["Usage Limit"] ??
                            "Usage Limit",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(Shared.colorPrimaryText)),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(Shared.colorSecondaryBackGround),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(
                                          Shared.colorSecondaryBackGround),
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
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(Shared.colorSecondaryBackGround),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(
                                          Shared.colorSecondaryBackGround),
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
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
                          Container(
                            height: 50,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(Shared.colorSecondaryBackGround),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color:
                                        Color(Shared.colorSecondaryBackGround),
                                    width: 0.5)),
                            child: DropdownButton(
                              dropdownColor:
                                  Color(Shared.colorSecondaryBackGround),
                              isExpanded: true,
                              underline: SizedBox(),
                              style: TextStyle(
                                  color: Color(Shared.colorPrimaryText)
                                      .withAlpha(128)),
                              value: notificationFrequency,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items:
                                  notificationFrequencies.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  notificationFrequency = newValue.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  SharedData().dictionary[Shared.selectedLanguage]?["Delete"] ??
                      "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            SharedData().dictionary[Shared.selectedLanguage]?['Delete Rule?'] ??
                                'Delete Rule?'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(SharedData()
                                          .dictionary[Shared.selectedLanguage]?[
                                      'Are you sure you want to delete this rule?'] ??
                                  'Are you sure you want to delete this rule?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(SharedData().dictionary[Shared.selectedLanguage]?['No']??"No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(SharedData().dictionary[Shared.selectedLanguage]?['Yes']??"Yes"),
                            onPressed: () {
                              DataBase.instance.deleteRule(rule.id!);
                              setState(() {
                                rule.appName = "";
                              });
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:  Text(
                                      SharedData().dictionary[Shared.selectedLanguage]?['Deleted successfully']??'Deleted successfully'
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children:  <Widget>[
                                          Text(
                                            SharedData().dictionary[Shared.selectedLanguage]?[
                                              'The rule was successfully deleted, click okay to continue.']??
                                              'The rule was successfully deleted, click okay to continue.'
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child:  Text(
                                          SharedData().dictionary[Shared.selectedLanguage]?['Okay']??"Okay"
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) => Navigator.of(context).pop());
                            },
                          ),
                        ],
                      );
                    },
                  ).then((value) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: Text(
                  SharedData().dictionary[Shared.selectedLanguage]?["Submit"] ??
                      "Submit",
                  style: TextStyle(color: Color(Shared.colorPrimaryText)),
                ),
                onPressed: () async {
                  DateTime day = DateTime.now();
                  String todaysId = day.year.toString() +
                      day.month.toString() +
                      day.day.toString();
                  RuleModel ruleModel = RuleModel(
                      appName: rule.appName,
                      appPackageName: rule.appPackageName,
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
                  int? id = (await DataBase.instance.getRuleId(ruleModel))!.id;
                  if (id == null) {
                    await DataBase.instance.createRule(ruleModel);
                  } else {
                    await DataBase.instance.updateRule(ruleModel.copy(id: id));
                  }
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Shared.blockUser = false;
    return rule.appName != ""
        ? FutureBuilder(
            future: getAppData(rule.appPackageName),
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
                  Application appSecondaryData = snapshot.data as Application;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Shared.colorSecondaryBackGround),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    height: 130,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //App Icon and Name
                            //App Icon and Name
                            Expanded(
                              flex: 9,
                              child: Row(
                                children: [
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: appSecondaryData
                                              is ApplicationWithIcon
                                          ? Image.memory(appSecondaryData.icon)
                                          : Icon(Icons.android_rounded)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(appSecondaryData.appName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color(Shared.colorPrimaryText))),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  _showMyDialog().then((value) async {
                                    rule = await DataBase.instance
                                            .getRuleId(rule) ??
                                        rule;
                                    this.widget.callback();
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Color(Shared.colorPrimaryText),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: (SharedData().dictionary[
                                                Shared.selectedLanguage]
                                            ?["Usage Limit"] ??
                                        "Usage Limit") +
                                    " : ",
                                style: TextStyle(
                                  color: Color(Shared.colorPrimaryText),
                                  fontSize: 13,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: rule.usageLimitInH.toString() +
                                          "h " +
                                          rule.usageLimitInMin.toString() +
                                          "min",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: (SharedData().dictionary[
                                                    Shared.selectedLanguage]
                                                ?["Category"] ??
                                            "Category") +
                                        " : ",
                                    style: TextStyle(
                                      color: Color(Shared.colorPrimaryText),
                                      fontSize: 13,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: getCategory(
                                                  appSecondaryData.category,
                                                  appSecondaryData.systemApp) ??
                                              "Unkown",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: ((SharedData().dictionary[
                                                    Shared.selectedLanguage]
                                                ?["Notification Frequency"] ??
                                            "Notification Frequency") +
                                        " : "),
                                    style: TextStyle(
                                      color: Color(Shared.colorPrimaryText),
                                      fontSize: 13,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: rule.notificationFrequency
                                                  .toString() +
                                              " " +
                                              (SharedData().dictionary[Shared
                                                          .selectedLanguage]
                                                      ?["per day"] ??
                                                  "per day"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
            })
        : SizedBox();
  }
}
