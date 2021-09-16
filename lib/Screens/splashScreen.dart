import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(Shared.colorPrimaryText),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    ),
                  ),
                ),
              )
            ),
            SizedBox(height: 10,),
            Text(
              "BREAKIT",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                fontFamily: "Yu Gothic UI",
                color: Colors.white
              ),
            ),
            SizedBox(height: 5,),
            Text(
              "Break Free Of Your Addiction",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                fontFamily: "Yu Gothic UI",
                color: Colors.white
              ),
            ),
          ],
        ),
      ), 
    );
  }
}