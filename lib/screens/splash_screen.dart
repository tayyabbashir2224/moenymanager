import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money_manager/helpers/db_helper.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/init_user_detail_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    dbh.initDB();
    check();
    super.initState();
  }

  void check() async {
    bool check;
    final prefs = await SharedPreferences.getInstance();
    check = prefs.getBool('userScreenVisited') ?? false;
    Duration d = Duration(milliseconds: 2000);
    if (check == true) {
      Timer(d, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );
      });
    } else {
      Timer(d, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          InitUserDetailScreen.id,
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "HM's Expenses Manager App",
                  maxLines: 1,
                  style: kSplashAppTitleStyle,
                ),
                SizedBox(height: 8.0),
                AutoSizeText(
                  'Manage your money',
                  style: kSplashAppSubTitleStyle,
                  maxLines: 1,
                ),
              ],
            ),
            Center(
              child: Image.asset(
                "assets/images/money_plant.png",
                height: 300.0,
                width: 300.0,
              ),
            ),
            SpinKitCircle(
              color: Colors.white,
              size: 60.0,
            ),
            Text(
              "Version 1.0",
              textAlign: TextAlign.center,
              style: kSplashVersionStyle,
            ),
          ],
        ),
      ),
    );
  }
}
