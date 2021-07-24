import 'package:break_it/Models/generalData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Models/Weekly.dart';

class DataBase{
  static final DataBase instance = DataBase._init();
  static Database? _database;
  DataBase._init();

  Future<Database> get database async {
    if(_database !=null) return _database!;
    _database = await _initDB('breakit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final intType = "INTEGER NOT NULL";
    final floatType = "FLOAT NOT NULL";
    final stringType = "TEXT NOT NULL";

    await db.execute(
"""
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
"""
    );
    await db.execute(
"""
CREATE TABLE $tableWeeklyInfo (
  ${WeeklyInfoFields.id} $idType,
  ${WeeklyInfoFields.idDay} $stringType,
  ${WeeklyInfoFields.idWeek} $stringType,
  ${WeeklyInfoFields.mainCategory} $stringType,
  ${WeeklyInfoFields.dayUsage} $floatType,
  ${WeeklyInfoFields.pos} $floatType
)
"""
    );
    await db.execute(
"""
CREATE TABLE $tableGeneraldata (
  ${GeneraldataFields.id} $idType,
  ${GeneraldataFields.title} $stringType,
  ${GeneraldataFields.data} $stringType
)
"""
    );
    //creating last check Activities
    await db.insert(tableGeneraldata, Generaldata(title: "LastCheckActivities", data: DateTime.now().subtract(Duration(minutes: 10)).toString()).toJson());
    //creating last check DashBoard
    await db.insert(tableGeneraldata, Generaldata(title: "LastCheckDashBoard", data: DateTime.now().subtract(Duration(minutes: 10)).toString()).toJson());
    //creating AverageCategory
    await db.insert(tableGeneraldata, Generaldata(title: "AverageCategory", data: "None").toJson());
    //creating AverageTimeOn
    await db.insert(tableGeneraldata, Generaldata(title: "AverageTimeOn", data: "0").toJson());
    //creating TodayCategory
    await db.insert(tableGeneraldata, Generaldata(title: "TodayCategory", data: "None").toJson());
    //creating TodayTimeOn
    await db.insert(tableGeneraldata, Generaldata(title: "TodayTimeOn", data: "0").toJson());
    //creating TodayTimeOn
    await db.insert(tableGeneraldata, Generaldata(title: "PermessionGranted", data: "false").toJson());
  }
  
  Future<Generaldata?> getPermessionGranted() async {
    final String title = "PermessionGranted";
    final db = await instance.database;
    final results = await db.query(
      tableGeneraldata,
      columns: GeneraldataFields.values,
      where: "${GeneraldataFields.title} = ?",
      whereArgs: [title],
    );
    if(results.isNotEmpty){
      return Generaldata.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<Generaldata?> getLastCheckActivities() async{
    final String title = "LastCheckActivities";
    final db = await instance.database;
    final results = await db.query(
      tableGeneraldata,
      columns: GeneraldataFields.values,
      where: "${GeneraldataFields.title} = ?",
      whereArgs: [title],
    );
    if(results.isNotEmpty){
      return Generaldata.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<Generaldata?> getLastCheckDashBoard() async{
    final String title = "LastCheckDashBoard";
    final db = await instance.database;
    final results = await db.query(
      tableGeneraldata,
      columns: GeneraldataFields.values,
      where: "${GeneraldataFields.title} = ?",
      whereArgs: [title],
    );
    if(results.isNotEmpty){
      return Generaldata.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<AppDailyInfo> createAppDailyInfo(AppDailyInfo appDailyInfo) async{
    final db = await instance.database;
    final id = await db.insert(tableAppDailyInfo, appDailyInfo.toJson());
    return appDailyInfo.copy(id : id);
  }

  Future<WeeklyInfo> createWeeklyInfo(WeeklyInfo weeklyInfo) async{
    final db = await instance.database;
    final id = await db.insert(tableWeeklyInfo, weeklyInfo.toJson());
    return weeklyInfo.copy(id : id);
  }

  Future<List<AppDailyInfo>?> readAppDailyInfo(DateTime day) async{
    final String idDay = day.year.toString()+day.month.toString()+day.day.toString();
    final db = await instance.database;
    final results = await db.query(
      tableAppDailyInfo,
      columns: AppDailyInfoFields.values,
      where: "${AppDailyInfoFields.date} = ?",
      whereArgs: [idDay],
      orderBy: "${AppDailyInfoFields.usageInMin} ASC"
    );
    if(results.isNotEmpty){
      return results.map((json) => AppDailyInfo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<WeeklyInfo>?> readWeeklyInfo(String idWeek) async{
    final db = await instance.database;
    final results = await db.query(
      tableWeeklyInfo,
      columns: WeeklyInfoFields.values,
      where: "${WeeklyInfoFields.idWeek} = ?",
      whereArgs: [idWeek],
      orderBy: "${WeeklyInfoFields.pos} ASC"
    );
    if(results.isNotEmpty){
      return results.map((json) => WeeklyInfo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<WeeklyInfo?> getTodaysWeeklyInfo() async{
    final db = await instance.database;
    DateTime today = DateTime.now();
    String idDay = today.year.toString()+today.month.toString()+today.day.toString();
    final results = await db.query(
      tableWeeklyInfo,
      columns: WeeklyInfoFields.values,
      where: "${WeeklyInfoFields.idDay} = ?",
      whereArgs: [idDay],
      orderBy: "${WeeklyInfoFields.pos} ASC"
    );
    if(results.isNotEmpty){
      return WeeklyInfo.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<int> updateAppDailyInfo(AppDailyInfo appDailyInfo) async{
    final db = await instance.database;
    return db.update(
      tableAppDailyInfo, 
      appDailyInfo.toJson(),
      where: "${AppDailyInfoFields.id} = ?",
      whereArgs :[appDailyInfo.id]
    );
  }

   Future updatePermessionGranted()async{
    final db = await instance.database;
    final Generaldata? generalData = await getPermessionGranted();
    if(generalData!=null){
      Generaldata newGeneralData = generalData.copy(data :  "true");
      return db.update(
        tableGeneraldata, 
        newGeneralData.toJson(),
        where: "${GeneraldataFields.id} = ?",
        whereArgs :[newGeneralData.id]
      );
    }
  }

  Future updateLastCheckActivities()async{
    final db = await instance.database;
    final Generaldata? generalData = await getLastCheckActivities();
    if(generalData!=null){
      Generaldata newGeneralData = generalData.copy(data :  DateTime.now().toString());
      return db.update(
        tableGeneraldata, 
        newGeneralData.toJson(),
        where: "${GeneraldataFields.id} = ?",
        whereArgs :[newGeneralData.id]
      );
    }
  }

  Future updateLastCheckDashBoard()async{
    final db = await instance.database;
    final Generaldata? generalData = await getLastCheckDashBoard();
    if(generalData!=null){
      Generaldata newGeneralData = generalData.copy(data :  DateTime.now().toString());
      return db.update(
        tableGeneraldata, 
        newGeneralData.toJson(),
        where: "${GeneraldataFields.id} = ?",
        whereArgs :[newGeneralData.id]
      );
    }
  }

  Future<int> updateWeeklyInfo(WeeklyInfo weeklyInfo) async{
    final db = await instance.database;
    return db.update(
      tableWeeklyInfo, 
      weeklyInfo.toJson(),
      where: "${WeeklyInfoFields.id} = ?",
      whereArgs :[weeklyInfo.id]
    );
  }

  Future<int> deleteAppDailyInfo(int id) async{
    final db = await instance.database;
    return db.delete(
      tableAppDailyInfo,
      where: "${AppDailyInfoFields.id} = ?",
      whereArgs :[id]
    );
  }

  Future<int> deleteTodaysAppDailyInfo() async{
    final String idDay = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString();
    final db = await instance.database;
    return db.delete(
      tableAppDailyInfo,
      where: "${AppDailyInfoFields.date} = ?",
      whereArgs :[idDay]
    );
  }

  Future<int> deleteWeeklyInfo(int id) async{
    final db = await instance.database;
    return db.delete(
      tableWeeklyInfo,
      where: "${WeeklyInfoFields.id} = ?",
      whereArgs :[id]
    );
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }
}