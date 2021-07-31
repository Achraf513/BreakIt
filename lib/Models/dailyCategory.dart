final String tableDailyCategory = "DailyCategory";

class DailyCategoryFields{

  static final values = [
    id,idDay, idWeek, usageInMin, category
  ];

  static final String id = "_id";
  static final String idDay = "idDay";
  static final String idWeek = "idWeek";
  static final String usageInMin = "usageInMin";
  static final String category = "category";
}

class  DailyCategory{
  final int? id;
  final String idDay;
  final String idWeek;
  final int usageInMin;
  final String category;
  const  DailyCategory({
    this.id,
    required this.idWeek,
    required this.idDay,
    required this.usageInMin,
    required this.category,
  });
  
  Map<String, Object?> toJson() => {
    DailyCategoryFields.id : id,
    DailyCategoryFields.idWeek : idWeek,
    DailyCategoryFields.idDay : idDay,
    DailyCategoryFields.category : category,
    DailyCategoryFields.usageInMin : usageInMin,
  };

  static  DailyCategory fromJson(Map<String, Object?> json) =>  DailyCategory(
    id: json[DailyCategoryFields.id] as int?,
    idWeek: json[DailyCategoryFields.idWeek] as String,
    idDay: json[DailyCategoryFields.idDay] as String,
    usageInMin: json[DailyCategoryFields.usageInMin] as int,
    category: json[DailyCategoryFields.category] as String,
  );

   DailyCategory copy({
    int? id,
    String? idWeek,
    String? idDay,
    int? usageInMin,
    String? category,
  }) =>  DailyCategory(
    id : id?? this.id,
    idWeek : idWeek?? this.idWeek,
    idDay : idDay?? this.idDay,
    usageInMin : usageInMin?? this.usageInMin,
    category : category?? this.category,
  );
}

