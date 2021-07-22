final String tableWeeklyInfo = "WeeklyInfo";

class WeeklyInfoFields{

  static final values = [
    id,idDay, idWeek, pos, dayUsage,mainCategory
  ];

  static final String id = "_id";
  static final String idDay = "idDay";
  static final String idWeek = "idWeek";
  static final String dayUsage = "dayUsage";
  static final String pos = "pos";
	static final String mainCategory = "mainCategory"; 
}

class WeeklyInfo{
  final int? id;
  final String idWeek;
  final String idDay;
  final double dayUsage;
  final double pos;
  final String mainCategory;
  const WeeklyInfo({
    this.id,
    required this.idWeek,
    required this.idDay,
    required this.dayUsage,
    required this.pos,
    required this.mainCategory
  });
  
  Map<String, Object?> toJson() => {
    WeeklyInfoFields.id : id,
    WeeklyInfoFields.idWeek : idWeek,
    WeeklyInfoFields.idDay : idDay,
    WeeklyInfoFields.pos : pos,
    WeeklyInfoFields.dayUsage : dayUsage,
    WeeklyInfoFields.mainCategory : mainCategory,
  };

  static WeeklyInfo fromJson(Map<String, Object?> json) => WeeklyInfo(
    id: json[WeeklyInfoFields.id] as int?,
    idWeek: json[WeeklyInfoFields.idWeek] as String,
    idDay: json[WeeklyInfoFields.idDay] as String,
    dayUsage: json[WeeklyInfoFields.dayUsage] as double,
    pos: json[WeeklyInfoFields.pos] as double,
    mainCategory: json[WeeklyInfoFields.mainCategory] as String,
  );

  WeeklyInfo copy({
    int? id,
    String? idWeek,
    String? idDay,
    double? dayUsage,
    double? pos,
    String? mainCategory,
  }) => WeeklyInfo(
    id : id?? this.id,
    idWeek : idWeek?? this.idWeek,
    idDay : idDay?? this.idDay,
    dayUsage : dayUsage?? this.dayUsage,
    pos : dayUsage?? this.pos,
    mainCategory : mainCategory?? this.mainCategory,
  );
}

