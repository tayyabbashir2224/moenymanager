import 'package:flutter/material.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const id = "setting_screen";
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
  var _chosenValue;

  @override
  void initState() {
    selectInitialValue();
    super.initState();
  }

  selectInitialValue() async {
    final prefs = await SharedPreferences.getInstance();
    int i = prefs.getInt('selectedColorIndex') ?? 0;
    _chosenValue = colors[i];
    setState(() {});
  }

  setColor(var val) async {
    final prefs = await SharedPreferences.getInstance();
    var index = colors.indexOf(val);
    prefs.setInt('selectedColorIndex', index);
    setState(() {
      kBackColor = colors[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  height: 100.0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: kBackColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Container(
                          height: 100.0,
                          width: 5.0,
                          color: kBackColor,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My",
                              style: kMainAppBarTextStyle.copyWith(
                                  color: kBackColor),
                            ),
                            Text(
                              "Money",
                              style: kMainAppBarTextStyle.copyWith(
                                  color: kBackColor),
                            ),
                            Text(
                              "Manager",
                              style: kMainAppBarTextStyle.copyWith(
                                  color: kBackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                  child: Text(
                    "PREFERENCES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kBackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    color: kBackColor,
                  ),
                  title: Text(
                    "Accent Color",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: DropdownButton(
                    value: _chosenValue,
                    onChanged: (val) {
                      setState(() {
                        _chosenValue = val;
                        setColor(val);
                      });
                    },
                    items: List.generate(
                      colors.length,
                      (index) => DropdownMenuItem(
                        value: colors[index],
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  shape: BoxShape.circle,
                                ),
                                height: 20.0,
                                width: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.money,
                    color: kBackColor,
                  ),
                  title: Text(
                    "Currency",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: DropdownButton(
                    value: _chosenValue,
                    onChanged: (val) {
                      setState(() {
                        _chosenValue = val;
                        setColor(val);
                      });
                    },
                    items: List.generate(
                      colors.length,
                      (index) => DropdownMenuItem(
                        value: colors[index],
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  shape: BoxShape.circle,
                                ),
                                height: 20.0,
                                width: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
