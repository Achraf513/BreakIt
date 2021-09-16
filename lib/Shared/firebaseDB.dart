import 'package:break_it/Models/FeedBack.dart';
import 'package:break_it/Models/Report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB{
  static final FirebaseDB _dataBase= new FirebaseDB._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirebaseDB(){
    return _dataBase;
  }
  FirebaseDB._internal();
 
  Future createReport(ReportModel report) async{
    try{
      await _firestore.collection("Reports").add(report.toJSON()); //add as many fields as u want in the map 
    } catch (error){
       print(error);
    }
  }

  Future createFeedBack(FeedBackModel feedBack) async{
    try{
      await _firestore.collection("FeedBack").add(feedBack.toJSON()); //add as many fields as u want in the map 
    } catch (error){
       print(error);
    }
  }
}
