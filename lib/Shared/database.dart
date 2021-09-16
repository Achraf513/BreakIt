import 'package:break_it/Models/RuleModel.dart';
import 'package:break_it/Models/dailyCategory.dart';
import 'package:break_it/Models/generalData.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Models/Weekly.dart';

class DataBase {
  static final DataBase instance = DataBase._init();
  static Database? _database;
  DataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('breakit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final intType = "INTEGER NOT NULL";
    final floatType = "FLOAT NOT NULL";
    final stringType = "TEXT NOT NULL";

    await db.execute("""
CREATE TABLE $tableAppDailyInfo (
  ${AppDailyInfoFields.id} $idType,
  ${AppDailyInfoFields.appName} $stringType,
  ${AppDailyInfoFields.date} $stringType,
  ${AppDailyInfoFields.appPackageName} $stringType,
  ${AppDailyInfoFields.category} $stringType,
  ${AppDailyInfoFields.usageInMin} $intType,
  ${AppDailyInfoFields.comparisonPerc} $intType,
  ${AppDailyInfoFields.usagePerc} $floatType
)
""");
    await db.execute("""
CREATE TABLE $tableWeeklyInfo (
  ${WeeklyInfoFields.id} $idType,
  ${WeeklyInfoFields.idDay} $stringType,
  ${WeeklyInfoFields.idWeek} $stringType,
  ${WeeklyInfoFields.usageInHours} $floatType,
  ${WeeklyInfoFields.pos} $floatType
)
""");
    await db.execute("""
CREATE TABLE $tableGeneraldata (
  ${GeneraldataFields.id} $idType,
  ${GeneraldataFields.title} $stringType,
  ${GeneraldataFields.data} $stringType
)
""");
    await db.execute("""
CREATE TABLE $tableDailyCategory (
  ${DailyCategoryFields.id} $idType,
  ${DailyCategoryFields.idDay} $stringType,
  ${DailyCategoryFields.idWeek} $stringType,
  ${DailyCategoryFields.category} $stringType,
  ${DailyCategoryFields.usageInMin} $intType
)
""");

    await db.execute("""
CREATE TABLE $tableRuleModel (
  ${RuleModelFields.id} $idType,
  ${RuleModelFields.appName} $stringType,
  ${RuleModelFields.appPackageName} $stringType,
  ${RuleModelFields.usageLimitInH} $intType,
  ${RuleModelFields.usageLimitInMin} $intType,
  ${RuleModelFields.notificationFrequency} $intType,
  ${RuleModelFields.todaysNotifications} $intType,
  ${RuleModelFields.lastDaysNotificationId} $stringType
)
""");
    //creating last check Activities
    await db.insert(
        tableGeneraldata,
        Generaldata(
                title: "LastCheckActivities",
                data: DateTime.now().subtract(Duration(minutes: 10)).toString())
            .toJson());
    //creating last check DashBoard
    await db.insert(
        tableGeneraldata,
        Generaldata(
                title: "LastCheckDashBoard",
                data: DateTime.now().subtract(Duration(minutes: 10)).toString())
            .toJson());
    //creating notifyTodayExceededAvarege
    await db.insert(tableGeneraldata,
        Generaldata(title: "NotifyTodayExceededAvarege", data: "false").toJson());
    //creating NotifyEarlier
    await db.insert(tableGeneraldata,
        Generaldata(title: "NotifyEarlier", data: "false").toJson());
    //creating DarkModeOn
    await db.insert(tableGeneraldata,
        Generaldata(title: "DarkModeOn", data: "false").toJson());
    //creating SelectedLanguage
    await db.insert(tableGeneraldata,
        Generaldata(title: "SelectedLanguage", data: "English").toJson());
    //creating AverageCategory
    await db.insert(tableGeneraldata,
        Generaldata(title: "AverageCategory", data: "None").toJson());
    //creating AverageTimeOn
    await db.insert(tableGeneraldata,
        Generaldata(title: "AverageTimeOn", data: "0").toJson());
    //creating TodayCategory
    await db.insert(tableGeneraldata,
        Generaldata(title: "TodayCategory", data: "None").toJson());
    //creating TodayTimeOn
    await db.insert(tableGeneraldata,
        Generaldata(title: "TodayTimeOn", data: "0").toJson());
    //creating TodayTimeOn
    await db.insert(tableGeneraldata,
        Generaldata(title: "PermessionGranted", data: "false").toJson());
  }

  Future<DailyCategory> createDailyCategory(DailyCategory dailyCategory) async {
    final db = await instance.database;
    final id = await db.insert(tableDailyCategory, dailyCategory.toJson());
    return dailyCategory.copy(id: id);
  }

  Future<AppDailyInfo> createAppDailyInfo(AppDailyInfo appDailyInfo) async {
    final db = await instance.database;
    final id = await db.insert(tableAppDailyInfo, appDailyInfo.toJson());
    return appDailyInfo.copy(id: id);
  }

  Future<WeeklyInfo> createWeeklyInfo(WeeklyInfo weeklyInfo) async {
    final db = await instance.database;
    final id = await db.insert(tableWeeklyInfo, weeklyInfo.toJson());
    return weeklyInfo.copy(id: id);
  }

  Future<RuleModel> createRule(RuleModel ruleModel) async {
    final db = await instance.database;
    final id = await db.insert(tableRuleModel, ruleModel.toJson());
    return ruleModel.copy(id: id);
  }

  Future<List<AppDailyInfo>?> readAppDailyInfo(DateTime day) async {
    final String idDay =
        day.year.toString() + day.month.toString() + day.day.toString();
    final db = await instance.database;
    final results = await db.query(tableAppDailyInfo,
        columns: AppDailyInfoFields.values,
        where: "${AppDailyInfoFields.date} = ?",
        whereArgs: [idDay],
        orderBy: "${AppDailyInfoFields.usageInMin} ASC");
    if (results.isNotEmpty) {
      return results.map((json) => AppDailyInfo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<WeeklyInfo>?> readWeeklyInfo(String idWeek) async {
    final db = await instance.database;
    final results = await db.query(tableWeeklyInfo,
        columns: WeeklyInfoFields.values,
        where: "${WeeklyInfoFields.idWeek} = ?",
        whereArgs: [idWeek],
        orderBy: "${WeeklyInfoFields.pos} ASC");
    if (results.isNotEmpty) {
      return results.map((json) => WeeklyInfo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<RuleModel>> readRules() async {
    final db = await instance.database;
    final results = await db.query(tableRuleModel,
        columns: RuleModelFields.values,
        orderBy: "${RuleModelFields.usageLimitInH} DESC");
    if (results.isNotEmpty) {
      return results.map((json) => RuleModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<RuleModel>> readRulesWithNotifLeft() async {
    final db = await instance.database;
    final results = await db.query(tableRuleModel,
        columns: RuleModelFields.values,
        where: "${RuleModelFields.todaysNotifications} > 0",
        orderBy: "${RuleModelFields.usageLimitInH} DESC");
    if (results.isNotEmpty) {
      return results.map((json) => RuleModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<RuleModel?> getRuleId(RuleModel ruleModel) async {
    final db = await instance.database;
    final results = await db.query(tableRuleModel,
        columns: RuleModelFields.values,
        where: "${RuleModelFields.appName} = ? AND ${RuleModelFields.appPackageName} = ?",
        whereArgs: [ruleModel.appName, ruleModel.appPackageName],
        orderBy: "${RuleModelFields.usageLimitInH} DESC");
    if (results.isNotEmpty) {
      return RuleModel.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<WeeklyInfo?> getTodaysWeeklyInfo() async {
    final db = await instance.database;
    DateTime today = DateTime.now();
    String idDay =
        today.year.toString() + today.month.toString() + today.day.toString();
    final results = await db.query(
      tableWeeklyInfo,
      columns: WeeklyInfoFields.values,
      where: "${WeeklyInfoFields.idDay} = ?",
      whereArgs: [idDay],
    );
    if (results.isNotEmpty) {
      return WeeklyInfo.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<String?> getTodaysDailyCategory() async {
    final db = await instance.database;
    DateTime today = DateTime.now();
    String idDay =
        today.year.toString() + today.month.toString() + today.day.toString();
    final results = await db.query(tableDailyCategory,
        columns: DailyCategoryFields.values,
        where: "${DailyCategoryFields.idDay} = ?",
        whereArgs: [idDay],
        orderBy: "${DailyCategoryFields.usageInMin} ASC");
    if (results.isNotEmpty) {
      return results.last["category"] as String;
    } else {
      await Future.delayed(Duration(seconds: 3));
      return await getThisWeeksCategory();
    }
  }

  Future<String?> getThisWeeksCategory() async {
    final db = await instance.database;
    DateTime startOfthisWeek = DateTime.now().subtract(
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
    while (startOfthisWeek.weekday != DateTime.monday) {
      startOfthisWeek = startOfthisWeek.subtract(Duration(days: 1));
    }
    String idWeek = startOfthisWeek.day.toString() +
        startOfthisWeek.month.toString() +
        startOfthisWeek.add(Duration(days: 6)).day.toString() +
        startOfthisWeek.add(Duration(days: 6)).month.toString() +
        startOfthisWeek.year.toString();

    final checkResult = await db.query(tableDailyCategory,
        columns: DailyCategoryFields.values,
        where: "${DailyCategoryFields.idWeek} = ?",
        whereArgs: [idWeek],
        orderBy: "${DailyCategoryFields.idDay} ASC");
    if (checkResult.isNotEmpty) {
      DateTime today = DateTime.now();
      String idDay =
          today.year.toString() + today.month.toString() + today.day.toString();
      if (checkResult.last["idDay"] == idDay) {
        final results = await db.rawQuery("""
SELECT ${DailyCategoryFields.category}, 
SUM (${DailyCategoryFields.usageInMin}) 
FROM $tableDailyCategory 
WHERE ${DailyCategoryFields.idWeek} = $idWeek
GROUP BY ${DailyCategoryFields.category};
ORDER BY ${DailyCategoryFields.usageInMin} DESC
      """);
        if (results.isNotEmpty) {
          return results.first["category"] as String;
        } else {
          return null;
        }
      } else {
        await Future.delayed(Duration(seconds: 3));
        return await getThisWeeksCategory();
      }
    } else {
      await Future.delayed(Duration(seconds: 3));
      return await getThisWeeksCategory();
    }
  }

  Future<Generaldata?> getGeneralData(String title) async {
    final db = await instance.database;
    final results = await db.query(
      tableGeneraldata,
      columns: GeneraldataFields.values,
      where: "${GeneraldataFields.title} = ?",
      whereArgs: [title],
    );
    if (results.isNotEmpty) {
      return Generaldata.fromJson(results.first);
    } else {
      return null;
    }
  }
 
 

  Future<int> updateAppDailyInfo(AppDailyInfo appDailyInfo) async {
    final db = await instance.database;
    return db.update(tableAppDailyInfo, appDailyInfo.toJson(),
        where: "${AppDailyInfoFields.id} = ?", whereArgs: [appDailyInfo.id]);
  }

  Future<int?> updateDailyCategory(DailyCategory dailyCategory) async {
    final db = await instance.database;
    final results = await db.query(
        tableDailyCategory,
        columns: DailyCategoryFields.values,
        where: "${DailyCategoryFields.idDay} = ? AND ${DailyCategoryFields.category} = ?",
        whereArgs: [dailyCategory.idDay, dailyCategory.category],);
    if (results.isNotEmpty) {
      /* dailyCategory = dailyCategory.copy(
          id: results.first["id"] as int,
          usageInMin:
              (results.first["usageInMin"] as int) + dailyCategory.usageInMin);
      print("new usageInMin : " + dailyCategory.usageInMin.toString()); */
      return /* await db.update(tableDailyCategory, dailyCategory.toJson(),
          where:
              "${DailyCategoryFields.idDay} = ? AND ${DailyCategoryFields.category} = ?",
          whereArgs: [dailyCategory.idDay, dailyCategory.category]); */ null;
    } else {
      DailyCategory test;
      test = await createDailyCategory(dailyCategory);
      return 2;
    }
  }

  Future updatePermessionGranted() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("PermessionGranted");
    if (generalData != null) {
      Generaldata newGeneralData = generalData.copy(data: "true");
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

  Future updateLastCheckActivities() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("LastCheckActivities");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: DateTime.now().toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

  
  Future updateDarkModeOn() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("DarkModeOn");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: Shared.darkThemeOn.toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

 Future updateSelectedLanguage() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("SelectedLanguage");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: Shared.selectedLanguage.toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

  
 Future updateNotifyEarlier() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("NotifyEarlier");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: Shared.notifyEarlier.toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }
   
 Future updateNotifyTodayExceededAvarege() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("NotifyTodayExceededAvarege");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: Shared.notifyTodayExceededAvarege.toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

  Future updateLastCheckDashBoard() async {
    final db = await instance.database;
    final Generaldata? generalData = await getGeneralData("LastCheckDashBoard");
    if (generalData != null) {
      Generaldata newGeneralData =
          generalData.copy(data: DateTime.now().toString());
      return db.update(tableGeneraldata, newGeneralData.toJson(),
          where: "${GeneraldataFields.id} = ?", whereArgs: [newGeneralData.id]);
    }
  }

  Future<int> updateWeeklyInfo(WeeklyInfo weeklyInfo) async {
    final db = await instance.database;
    return db.update(tableWeeklyInfo, weeklyInfo.toJson(),
        where: "${WeeklyInfoFields.id} = ?", whereArgs: [weeklyInfo.id]);
  }

  Future<int> updateRule(RuleModel ruleModel) async {
    final db = await instance.database;
    return db.update(tableRuleModel, ruleModel.toJson(),
        where: "${RuleModelFields.id} = ?", whereArgs: [ruleModel.id]);
  }

  Future<int> deleteAppDailyInfo(int id) async {
    final db = await instance.database;
    return db.delete(tableAppDailyInfo,
        where: "${AppDailyInfoFields.id} = ?", whereArgs: [id]);
  }

  Future<int> deleteTodaysAppDailyInfo() async {
    final String idDay = DateTime.now().year.toString() +
        DateTime.now().month.toString() +
        DateTime.now().day.toString();
    final db = await instance.database;
    return db.delete(tableAppDailyInfo,
        where: "${AppDailyInfoFields.date} = ?", whereArgs: [idDay]);
  }

  Future<int> deleteWeeklyInfo(int id) async {
    final db = await instance.database;
    return db.delete(tableWeeklyInfo,
        where: "${WeeklyInfoFields.id} = ?", whereArgs: [id]);
  }

  Future<int> deleteRule(int id) async {
    final db = await instance.database;
    return db.delete(tableRuleModel,
        where: "${RuleModelFields.id} = ?", whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
