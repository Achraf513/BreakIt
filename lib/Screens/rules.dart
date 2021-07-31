import 'package:break_it/Screens/addNewRule.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({ Key? key }) : super(key: key);

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(Shared.color_primary1),
        child: Icon(Icons.add),
        onPressed: () async {
          await SharedData().getAppList();
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewRule()),);
        },
      ),
    );
  }
}