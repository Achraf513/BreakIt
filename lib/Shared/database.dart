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

  Future<int> updateAppDailyInfo(AppDailyInfo appDailyInfo) async{
    final db = await instance.database;
    return db.update(
      tableAppDailyInfo, 
      appDailyInfo.toJson(),
      where: "${AppDailyInfoFields.id} = ?",
      whereArgs :[appDailyInfo.id]
    );
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