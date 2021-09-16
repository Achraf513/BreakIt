class ReportFields {
  static final String title = "title";
  static final String description = "description";
}

class ReportModel {
  final String title;
  final String description;

  ReportModel({
    required this.title,
    required this.description,
  });

  Map<String, Object?> toJSON() {
    return {
      ReportFields.title: title,
      ReportFields.description: description,
    };
  }

  static ReportModel fromJson(Map<String, Object?> json) => ReportModel(
        title: json[ReportFields.title] as String,
        description: json[ReportFields.description] as String,
      );

  ReportModel copy({
    String? title,
    String? description,
  }) =>
      ReportModel(
        title: title ?? this.title,
        description: description ?? this.description,
      );
}
