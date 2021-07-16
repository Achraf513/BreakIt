import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';

class Shared {
  static const int color_primaryViolet = 0xFF430064;
  static const int color_secondaryViolet = 0xFF9E00EC;
  static const int color_primaryGrey = 0xFFF6F5F6;
  static const int color_secondaryGrey = 0xFF655C98;
  static const int pieChartColor_yellow = 0xFF58508d;
  static const int pieChartColor_green = 0xFFbc5090;
  static const int pieChartColor_blue = 0xFFff6361;
  static const int pieChartColor_red = 0xFFffa600;
}

class SharedData {
  static final SharedData _sharedData = new SharedData._internal();
  int totalUsage = 0;
  factory SharedData() {
    return _sharedData;
  }


  Future<Application?> getIcon(String packageName) async {
    Future<Application?> app = DeviceApps.getApp(packageName, true);
    return app;
  }

  Future<List<AppUsageInfo>> getUsageStats(DateTime startDate,  DateTime endDate) async {
    int totalUsage_ = 0;
    try { 
      Future<List<AppUsageInfo>> infos = AppUsage.getAppUsage(startDate, endDate);
      infos.then((value) 
        {
          value.sort((a, b) => a.usage.compareTo(b.usage));
          for (var app in value) {
            totalUsage_+=app.usage.inMinutes;
          }
          totalUsage = totalUsage_;
        }
      );
      return infos;
    } on AppUsageException catch (exception) {
      print(exception);
      return [];
    }
  }

  SharedData._internal();
}
