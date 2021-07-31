final String tableWeeklyInfo = "WeeklyInfo";

class WeeklyInfoFields{

  static final values = [
    id,idDay, idWeek, pos, usageInHours
  ];

  static final String id = "_id";
  static final String idDay = "idDay";
  static final String idWeek = "idWeek";
  static final String usageInHours = "usageInHours";
  static final String pos = "pos";
}

class WeeklyInfo{
  final int? id;
  final String idWeek;
  final String idDay;
  final double usageInHours;
  final double pos;
  const WeeklyInfo({
    this.id,
    required this.idWeek,
    required this.idDay,
    required this.usageInHours,
    required this.pos,
  });
  
  Map<String, Object?> toJson() => {
    WeeklyInfoFields.id : id,
    WeeklyInfoFields.idWeek : idWeek,
    WeeklyInfoFields.idDay : idDay,
    WeeklyInfoFields.pos : pos,
    WeeklyInfoFields.usageInHours : usageInHours,
  };

  static WeeklyInfo fromJson(Map<String, Object?> json) => WeeklyInfo(
    id: json[WeeklyInfoFields.id] as int?,
    idWeek: json[WeeklyInfoFields.idWeek] as String,
    idDay: json[WeeklyInfoFields.idDay] as String,
    usageInHours: json[WeeklyInfoFields.usageInHours] as double,
    pos: json[WeeklyInfoFields.pos] as double,
  );

  WeeklyInfo copy({
    int? id,
    String? idWeek,
    String? idDay,
    double? usageInHours,
    double? pos,
    String? mainCategory,
  }) => WeeklyInfo(
    id : id?? this.id,
    idWeek : idWeek?? this.idWeek,
    idDay : idDay?? this.idDay,
    usageInHours : usageInHours?? this.usageInHours,
    pos : pos?? this.pos,
  );
}

