import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/generalData.dart';
import 'package:break_it/Screens/HomeScreen.dart';
import 'package:break_it/Screens/splashScreen.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/database.dart';
import 'package:flutter/material.dart';

class GrantPermession extends StatelessWidget {
  const GrantPermession({Key? key}) : super(key: key);

  Future<List<AppUsageInfo>> askForPermession() async {
    try {
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(
          DateTime.now().subtract(Duration(days: 2)), DateTime.now());
      //await DeviceApps.getApp("packageName");
      return infos;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataBase.instance.getPermessionGranted(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            if(snapshot.hasData){
              Generaldata permessionGranted = snapshot.data as Generaldata;
              if(permessionGranted.data == "true"){
                return HomeScreen();
              }else{
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Welcome to BreakIt",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(Shared.color_primary1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "In order to use the app, you need to grant it the permession to access the packages usage states.\nClick the 'Allow' button and select BreakIt, then grant it the permession.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(Shared.color_primary1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(Shared.color_primary1)),
                              child: TextButton(
                                onPressed: () async {
                                  List<AppUsageInfo> infos = await askForPermession();
                                  if (infos.length != 0) {
                                    await DataBase.instance.updatePermessionGranted();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  }
                                },
                                child: Text(
                                  "Allow",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }else{
            return SplashScreen();
          }
          return SplashScreen();
        }
      );
  }
}
