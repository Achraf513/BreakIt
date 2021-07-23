final String tableGeneraldata = "GeneralData";

class GeneraldataFields{
  
  static final values = [ id, title, data ];

  static final String id = "_id";
  static final String title = "title"; // TimeOn, Category, LastCheck
  static final String data = "data"; // if TimeOn : (time in minutes).toString()  , if Category : Category.toString() , LastCheck : DateTime.toString()
}

class Generaldata {

  final int? id;
  final String title;
  final String data;

  const Generaldata({
    this.id, 
    required this.title,
    required this.data,
  });

  Map<String, Object?> toJson() => {
    GeneraldataFields.id : id,
    GeneraldataFields.title : title,
    GeneraldataFields.data : data,
  };

  static Generaldata fromJson(Map<String, Object?> json) => Generaldata(
    id: json[GeneraldataFields.id] as int?,
    title: json[GeneraldataFields.title] as String,
    data: json[GeneraldataFields.data] as String,
  );

  Generaldata copy({
    int? id,
    String? title,
    String? data,
  }) => Generaldata(
    id : id?? this.id,
    title : title?? this.title,
    data : data?? this.data,
  );
}

