import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';

class AddNewRule extends StatefulWidget {
  const AddNewRule({ Key? key }) : super(key: key);

  @override
  _AddNewRuleState createState() => _AddNewRuleState();
}

class _AddNewRuleState extends State<AddNewRule> {
  String appSelecte = 'Select App';
  String notificationFrequency = "Daily";
  String hoursSelected = "1 Hour";
  String minutesSelected = "15 Min";
  var hours = ["0 Hours","1 Hour","2 Hours","3 Hours","4 Hours","5 Hours","6 Hours","7 Hours","8 Hours","9 Hours","10 Hours"];
  var minutes = ["5 Min","10 Min","15 Min","20 Min","25 Min","30 Min","35 Min","40 Min","45 Min","50 Min","55 Min"];
  var items =  ['Select App','Daily','15 Min','1 Hour','notificationFrequency','value1','value2','value3','value4','value5','value6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.color_primaryViolet),
        title: Text(
          "New Rule"
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Color(Shared.color_primaryGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Application",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(Shared.color_primaryViolet)
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(Shared.color_primaryViolet),width: 0.5)
                    ),
                    child: 
                    DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Color(Shared.color_secondaryGrey)
                      ),
                      value: appSelecte,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items:items.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(items)
                            );
                        }
                        ).toList(),
                      onChanged: ( newValue){
                        setState(() {
                          appSelecte = newValue.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),  
            ),
            SizedBox(height:10),
            Container(
              decoration: BoxDecoration(
                color: Color(Shared.color_primaryGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Usage Limit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(Shared.color_primaryViolet)
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(Shared.color_primaryViolet),width: 0.5)
                    ),
                    child: 
                    DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Color(Shared.color_secondaryGrey)
                      ),
                      value: hoursSelected,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items:hours.map((String hours) {
                            return DropdownMenuItem(
                                value: hours,
                                child: Text(hours)
                            );
                        }
                        ).toList(),
                      onChanged: ( newValue){
                        setState(() {
                          hoursSelected = newValue.toString();
                        });
                      },
                    ),
                  ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 5,
                        child: Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(Shared.color_primaryViolet),width: 0.5)
                    ),
                    child: 
                    DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Color(Shared.color_secondaryGrey)
                      ),
                      value: minutesSelected,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items:minutes.map((String minutes) {
                            return DropdownMenuItem(
                                value: minutes,
                                child: Text(minutes)
                            );
                        }
                        ).toList(),
                      onChanged: ( newValue){
                        setState(() {
                          minutesSelected = newValue.toString();
                        });
                      },
                    ),
                  ),
                      ),
                    ],
                  ),
                ],
              ),  
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: Color(Shared.color_primaryGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notification Frequency",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(Shared.color_primaryViolet)
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(Shared.color_primaryViolet),width: 0.5)
                    ),
                    child: 
                    DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Color(Shared.color_secondaryGrey)
                      ),
                      value: notificationFrequency,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items:items.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(items)
                            );
                        }
                        ).toList(),
                      onChanged: ( newValue){
                        setState(() {
                          notificationFrequency = newValue.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),  
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(Shared.color_primaryGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Lock if time limit reached",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(Shared.color_primaryViolet)
                    ),
                  ),
                  SizedBox(width:55),
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        height: 25,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(Shared.color_secondaryGrey)
                        )
                      ),
                      Row(
                        children: [
                          SizedBox(width: 2,),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white
                            )
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),  )
          ],),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15)
                ),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Center(child: Text("Cancel",style: TextStyle(color: Colors.white),)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color(Shared.color_primaryViolet),
                  borderRadius: BorderRadius.circular(15)
                ),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Center(child: Text("Submit",style: TextStyle(color: Colors.white),)),
              ),
            ),
          ],),
        ),
      ),
    );
  }
}