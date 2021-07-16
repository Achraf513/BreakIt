import 'package:break_it/addNewRule.dart';
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
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewRule()),);
        },
      ),
    );
  }
}