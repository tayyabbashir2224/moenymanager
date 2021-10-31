import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/screens/categories_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/init_user_detail_screen.dart';
import 'package:money_manager/screens/new_transaction_screen.dart';
import 'package:money_manager/screens/setting_screen.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:money_manager/screens/transaction_detail_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
//import 'package:money_manager/screens/transaction_update_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  visited = prefs.getBool('isOnBoardingVisited') ?? false;
  var i = prefs.getInt('selectedColorIndex') ?? 0;
  kBackColor = colors[i];
  runApp(MyApp());
}

bool visited = false;

List colors = [
  Color(0xFF1B54A9),
  Colors.black,
  Colors.deepPurple,
  Colors.teal,
  Colors.pink,
  Colors.redAccent,
  Colors.brown,
  Colors.orange,
  Colors.deepOrange,
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HM Expense Manager',
      theme: ThemeData(
        fontFamily: 'FiraSans',
      ),
      themeMode: ThemeMode.system,
      initialRoute: visited ? SplashScreen.id : OnBoardingScreen.id,
      routes: {
        OnBoardingScreen.id: (context) => OnBoardingScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        CategoriesScreen.id: (context) => CategoriesScreen(),
        NewTransactionScreen.id: (context) => NewTransactionScreen(),
        TransactionDetailScreen.id: (context) => TransactionDetailScreen(),
        //TransactionUpdateScreen.id: (context) => TransactionUpdateScreen(),
        InitUserDetailScreen.id: (context) => InitUserDetailScreen(),
        SettingScreen.id: (context) => SettingScreen(),
      },
    );
  }
}
