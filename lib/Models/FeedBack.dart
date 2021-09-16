class FeedBackFields {
  static final String description = "description";
}

class FeedBackModel {
  final String description;

  FeedBackModel({
    required this.description,
  });

  Map<String, Object?> toJSON() {
    return {
      FeedBackFields.description: description,
    };
  }

  static FeedBackModel fromJson(Map<String, Object?> json) => FeedBackModel(
        description: json[FeedBackFields.description] as String,
      );

  FeedBackModel copy({
    String? description,
  }) =>
      FeedBackModel(
        description: description ?? this.description,
      );
}
