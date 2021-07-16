import 'package:break_it/Shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(Shared.color_primaryViolet),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/5,
              child: SvgPicture.asset(
                "assets/icons/Logo.svg"
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "BREAKIT",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w400,
                fontFamily: "Yu Gothic UI",
                color: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Break Free Of Your Addiction",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                fontFamily: "Yu Gothic UI",
                color: Colors.white
              ),
            )
          ],
        ),
      ), 
    );
  }
}