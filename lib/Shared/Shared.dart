import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';

class Shared {
  static const int color_primaryViolet = 0xFF430064;
  static const int color_secondaryViolet = 0xFF9E00EC;
  static const int color_primaryGrey = 0xFFF6F5F6;
  static const int color_secondaryGrey = 0xFF655C98;
  static const int pieChartColor_yellow = 0xFF58508d;
  static const int pieChartColor_violet = 0xFFbc5090;
  static const int pieChartColor_blue = 0xFFff6361;
  static const int pieChartColor_red = 0xFFffa600;
  static const int pieChartColor_green = 0xFF34ad1d;
}

class SharedData {
  static final SharedData _sharedData = new SharedData._internal();
  int totalUsage = 0;
  int totalUsageWithoutSystem = 0;
  factory SharedData() {
    return _sharedData;
  }
  SharedData._internal();

  String getCategory(ApplicationCategory appCategory, bool isSysApp){
    if(isSysApp){
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

  Future<Application?> getIcon(String packageName) async {
    Future<Application?> app = DeviceApps.getApp(packageName, true);
    return app;
  }

  Future<List<AppUsageInfo>> getUsageStats(
      DateTime startDate, DateTime endDate, bool updateTotalUsage) async {
    int totalUsageLocal = 0;
    int totalUsageWithoutSystemLocal = 0;
    try {
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      infos.sort((a, b) => a.usage.compareTo(b.usage));
      if (updateTotalUsage) {
        for (var app in infos) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          if (moreDetails != null) {
            if (!moreDetails.systemApp) {
              totalUsageWithoutSystemLocal += app.usage.inMinutes;
            }
          }
          totalUsageLocal += app.usage.inMinutes;
        }
        totalUsage = totalUsageLocal;
        totalUsageWithoutSystem = totalUsageWithoutSystemLocal;
      }
      return infos;
    } on AppUsageException catch (exception) {
      print(exception);
      return [];
    }
  }

  Future<List<AppDailyInfo>> getDailyUsageStats(
      DateTime day ) async {
    List<AppDailyInfo>? result = await DataBase.instance.readAppDailyInfo(day);
    if (result!=null){
      return result;
    } else {
      int totalUsageLocal = 0;
      List<AppDailyInfo> result = [];
      try {
        List<AppUsageInfo> infos =
            await AppUsage.getAppUsage(day, day.add(Duration(days: 1)));
        infos.sort((a, b) => a.usage.compareTo(b.usage));
        for (var app in infos) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          totalUsageLocal += app.usage.inMinutes;
        }
        for (var app in infos) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          if (moreDetails != null) {
            AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: app.appName,
              appPackageName: app.packageName,
              category: getCategory(moreDetails.category, moreDetails.systemApp),
              usageInMin: app.usage.inMinutes,
              date: day.year.toString()+day.month.toString()+day.day.toString(),
              comparisonPerc: 12,///MAKE IT DYNAMIC
              usagePerc: double.parse(((app.usage.inMinutes/totalUsageLocal)*100).toStringAsFixed(2))
            );
            DataBase.instance.createAppDailyInfo(appDailyInfo);
            result.add(appDailyInfo);
          } else{
            AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: app.appName,
              appPackageName: app.packageName,
              category: "Uknown",
              usageInMin: app.usage.inMinutes,
              date: day.year.toString()+day.month.toString()+day.day.toString(),
              comparisonPerc: 12,///MAKE IT DYNAMIC
              usagePerc: double.parse(((app.usage.inMinutes/totalUsageLocal)*100).toStringAsFixed(2))
            );
            DataBase.instance.createAppDailyInfo(appDailyInfo);
            result.add(appDailyInfo);
          }
        } 
        return result;
      } catch (exception) {
        print(exception);
        return [];
      }
    }
  }

}
