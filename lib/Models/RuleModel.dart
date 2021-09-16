final String tableRuleModel = "Rules";

class RuleModelFields{

  static final values = [
    id,appName, appPackageName, usageLimitInH, usageLimitInMin, notificationFrequency,todaysNotifications, lastDaysNotificationId
  ];

  static final String id = "_id";
  static final String appName = "appName";
  static final String appPackageName = "appPackageName";
  static final String usageLimitInH = "usageLimitInH";
  static final String usageLimitInMin = "usageLimitInMin";
  static final String notificationFrequency = "notificationFrequency";
  static final String todaysNotifications = "todaysNotifications";
  static final String lastDaysNotificationId = "lastDaysNotificationId";
}

class  RuleModel{
  final int? id;
  String appName;
  String appPackageName;
  int usageLimitInH;
  int usageLimitInMin;
  int notificationFrequency;
  int todaysNotifications;
  String lastDaysNotificationId;
  RuleModel({
    this.id,
    required this.appPackageName,
    required this.appName,
    required this.usageLimitInH,
    required this.usageLimitInMin,
    required this.notificationFrequency,
    required this.todaysNotifications,
    required this.lastDaysNotificationId,
  });
  
  Map<String, Object?> toJson() => {
    RuleModelFields.id : id,
    RuleModelFields.appPackageName : appPackageName,
    RuleModelFields.appName : appName,
    RuleModelFields.usageLimitInMin : usageLimitInMin,
    RuleModelFields.usageLimitInH : usageLimitInH,
    RuleModelFields.notificationFrequency : notificationFrequency,
    RuleModelFields.todaysNotifications : todaysNotifications,
    RuleModelFields.lastDaysNotificationId : lastDaysNotificationId,
  };

  static  RuleModel fromJson(Map<String, Object?> json) =>  RuleModel(
    id: json[RuleModelFields.id] as int?,
    appPackageName: json[RuleModelFields.appPackageName] as String,
    appName: json[RuleModelFields.appName] as String,
    usageLimitInH: json[RuleModelFields.usageLimitInH] as int,
    usageLimitInMin: json[RuleModelFields.usageLimitInMin] as int,
    notificationFrequency: json[RuleModelFields.notificationFrequency] as int,
    todaysNotifications: json[RuleModelFields.todaysNotifications] as int,
    lastDaysNotificationId: json[RuleModelFields.lastDaysNotificationId] as String,
  );

   RuleModel copy({
    int? id,
    String? idWeek,
    String? idDay,
    int? usageInMin,
    int? usageLimitInMin,
    int? notificationFrequency,
    int? todaysNotifications,
    String? lastDaysNotificationId,
  }) =>  RuleModel(
    id : id?? this.id,
    appPackageName : idWeek?? this.appPackageName,
    appName : idDay?? this.appName,
    usageLimitInH : usageInMin?? this.usageLimitInH,
    usageLimitInMin : usageLimitInMin?? this.usageLimitInMin,
    notificationFrequency : notificationFrequency?? this.notificationFrequency,
    todaysNotifications : todaysNotifications?? this.todaysNotifications,
    lastDaysNotificationId : lastDaysNotificationId?? this.lastDaysNotificationId,
  );
}

