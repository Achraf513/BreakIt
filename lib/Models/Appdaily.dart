final String tableAppDailyInfo = "AppDailyInfo";

class AppDailyInfoFields{
  
  static final values = [
    id,date, appName, appPackageName,category,usagePerc,usageInMin,comparisonPerc
  ];

  static final String id = "_id";
  static final String date = "date";
  static final String appName = "appName";
	static final String appPackageName = "appPackageName"; 
	static final String category = "category";
	static final String usageInMin ="usageInMin";
	static final String usagePerc = "usagePerc";
	static final String comparisonPerc = "comparisonPerc";
}

class AppDailyInfo {

  final int? id;
  final String date;
  final String appName;
	final String appPackageName; 
	final String category;
	final int usageInMin;
	final double usagePerc;
	final int comparisonPerc;

  const AppDailyInfo({
    this.id, 
    required this.date,
    required this.appName,
    required this.appPackageName,
    required this.category,
    required this.usageInMin,
    required this.usagePerc,
    required this.comparisonPerc
  });

  Map<String, Object?> toJson() => {
    AppDailyInfoFields.id : id,
    AppDailyInfoFields.date : date,
    AppDailyInfoFields.appName : appName,
    AppDailyInfoFields.appPackageName : appPackageName,
    AppDailyInfoFields.category : category,
    AppDailyInfoFields.usageInMin : usageInMin,
    AppDailyInfoFields.usagePerc : usagePerc,
    AppDailyInfoFields.comparisonPerc : comparisonPerc
  };

  static AppDailyInfo fromJson(Map<String, Object?> json) => AppDailyInfo(
    id: json[AppDailyInfoFields.id] as int?,
    date: json[AppDailyInfoFields.date] as String,
    appName: json[AppDailyInfoFields.appName] as String,
    appPackageName: json[AppDailyInfoFields.appPackageName] as String,
    category: json[AppDailyInfoFields.category] as String,
    usageInMin: json[AppDailyInfoFields.usageInMin] as int,
    usagePerc: json[AppDailyInfoFields.usagePerc] as double,
    comparisonPerc: json[AppDailyInfoFields.comparisonPerc] as int,
  );

  AppDailyInfo copy({
    int? id,
    String? date,
    String? appName,
    String? appPackageName, 
    String? category,
    int? usageInMin,
    double? usagePerc,
    int? comparisonPerc,
  }) => AppDailyInfo(
    id : id?? this.id,
    date : date?? this.date,
    appName : appName?? this.appName,
    appPackageName : appPackageName?? this.appPackageName,
    category : category?? this.category,
    usageInMin : usageInMin?? this.usageInMin,
    usagePerc : usagePerc?? this.usagePerc,
    comparisonPerc : comparisonPerc?? this.comparisonPerc,
  );
}

