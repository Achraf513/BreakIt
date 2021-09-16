import 'package:break_it/Shared/Shared.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              child: Center(
                  child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Shared.darkThemeOn
                            ? Color(Shared.colorSecondaryBackGround)
                            : Color(Shared.colorPrimaryText),
                      ),
                      child: Image.asset(
                        "assets/icons/Logo.png",
                        width: 150,
                        height: 150,
                      ))),
            ),
            SizedBox(height: 35),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]?["What is BreakIt?"]??"What is BreakIt?",
              style: TextStyle(
                  color: Color(Shared.colorPrimaryText),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
                SharedData().dictionary[Shared.selectedLanguage]?[
                        "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management."] ??
                    "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(Shared.colorPrimaryText),
                    fontWeight: FontWeight.w300)),
            SizedBox(height: 15),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]
                      ?["Main functionalities of BreakIt?"] ??
                  "Main functionalities of BreakIt?",
              style: TextStyle(
                  color: Color(Shared.colorPrimaryText),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
                SharedData().dictionary[Shared.selectedLanguage]?[
                        "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded."] ??
                    "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(Shared.colorPrimaryText),
                    fontWeight: FontWeight.w300)),
            SizedBox(height: 15),
            Text(
              SharedData().dictionary[Shared.selectedLanguage]
                      ?["Does it consume battery?"] ??
                  "Does it consume battery?",
              style: TextStyle(
                  color: Color(Shared.colorPrimaryText),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
                SharedData().dictionary[Shared.selectedLanguage]?[
                        "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low."] ??
                    "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low.",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(Shared.colorPrimaryText),
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}
