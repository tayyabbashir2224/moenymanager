import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_manager/components/custom_balance_card.dart';
import 'package:money_manager/components/emptylist_container_msg.dart';
import 'package:money_manager/helpers/db_helper.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/models/user_data_model.dart';
import 'package:money_manager/screens/categories_screen.dart';
import 'package:money_manager/screens/about_screen.dart';
import 'package:money_manager/screens/new_transaction_screen.dart';
import 'package:money_manager/screens/setting_screen.dart';
import 'package:money_manager/screens/transaction_detail_screen.dart';
import 'package:money_manager/screens/transaction_update_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/utils/get_progress_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:money_manager/components/custom_drawer.dart' as myDrawer;
//import 'package:money_manager/main.dart';

User currUser;

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<myDrawer.SwipeDrawerState> drawerKey =
      GlobalKey<myDrawer.SwipeDrawerState>();

  int selectedMonth;
  Future fetchedMainData;
  Future fetchedTransactions;
  Future fetchedUser;
  List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int currYear; // stores current year
  int selected; // stores selected month 0 to 11

  AnimationController _animationController;
  bool _isPlaying = false;

  _onHorizontalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.right) {
        if (drawerKey.currentState.isOpened() == false) {
          drawerKey.currentState.openDrawer();
          _animationController.forward();
          _isPlaying = true;
        }
      } else {
        if (drawerKey.currentState.isOpened()) {
          drawerKey.currentState.closeDrawer();
          _animationController.reverse();
          _isPlaying = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    dbh.initDB();
    DateTime curr = DateTime.now();
    selectedMonth = curr.month - 1;
    selected = selectedMonth;
    currYear = curr.year;
    fetchedMainData = dbh.getMainData(curr.month, curr.year);
    fetchedTransactions = dbh.getTransactions(curr.month, curr.year);
    fetchedUser = dbh.getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: myDrawer.SwipeDrawer(
        drawer: buildDrawer(),
        key: drawerKey,
        handleCloseAnimation: () {
          setState(() {
            _isPlaying = false;
            _animationController.reverse();
          });
        },
        radius: 20,
        backgroundColor: kBackColor,
        bodyBackgroundPeekSize: 50,
        hasClone: false,
        bodySize: 100.0,
        child: SimpleGestureDetector(
          onHorizontalSwipe: _onHorizontalSwipe,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      height: 100.0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isPlaying = !_isPlaying;
                                _isPlaying
                                    ? _animationController.forward()
                                    : _animationController.reverse();
                              });
                              if (drawerKey.currentState.isOpened()) {
                                drawerKey.currentState.closeDrawer();
                              } else {
                                drawerKey.currentState.openDrawer();
                              }
                            },
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: _animationController,
                              color: kBackColor,
                            ),
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
                            flex: 1,
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
                                  "Expense",
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
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(3.0),
                              ),
                              child: Row(
                                children: [
                                  // Navigate to the Search Screen
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.search)),
                                  Text(
                                    months[selectedMonth].substring(0, 3),
                                    style: TextStyle(
                                      color: kBackColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: kBackColor,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.50,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: kBackColor,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.minimize,
                                                              color:
                                                                  Colors.white,
                                                              size: 35.0,
                                                            ),
                                                            splashColor:
                                                                Colors.grey,
                                                            onPressed: () {
                                                              setState(() {
                                                                currYear--;
                                                              });
                                                            },
                                                          ),
                                                          CircleAvatar(
                                                            radius: 40.0,
                                                            backgroundColor:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        0.2),
                                                            child: Text(
                                                              currYear
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                              size: 35.0,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                currYear++;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          flex: 6,
                                                          child: Container(
                                                            child:
                                                                CupertinoScrollbar(
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                        i) {
                                                                  return ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        selected =
                                                                            i;
                                                                      });
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      elevation:
                                                                          MaterialStateProperty.all(
                                                                              0.0),
                                                                      padding: MaterialStateProperty.all(
                                                                          EdgeInsets
                                                                              .zero),
                                                                      backgroundColor:
                                                                          MaterialStateProperty
                                                                              .all(
                                                                        selected ==
                                                                                i
                                                                            ? kBackColor.withOpacity(0.15)
                                                                            : kBackColor.withOpacity(0.025),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        months[
                                                                            i],
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                itemCount:
                                                                    months
                                                                        .length,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  "CANCEL",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBackColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    selectedMonth =
                                                                        selected;
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    refreshData(
                                                                        selectedMonth +
                                                                            1,
                                                                        currYear);
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "OK",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBackColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: FutureBuilder(
                        future: fetchedMainData,
                        builder: (context, ss) {
                          if (ss.hasData) {
                            if (ss != null) {
                              return ss.data.length == 0
                                  ? CustomBalanceCard(
                                      data: new MainData(
                                        balance: 0.0,
                                        income: 0.0,
                                        expense: 0.0,
                                        month: selectedMonth,
                                        year: currYear,
                                      ),
                                    )
                                  : CustomBalanceCard(
                                      data: ss.data[0],
                                    );
                            }
                          }
                          return getProgressIndicator();
                        },
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: fetchedTransactions,
                        builder: (context, ss) {
                          if (ss.hasData) {
                            if (ss.data != null) {
                              var data = ss.data;
                              Set uniqueDates = {};
                              for (int i = 0; i < data.length; i++) {
                                uniqueDates.add(data[i].date);
                              }
                              var dates = List.from(uniqueDates);
                              return data.length == 0
                                  ? Center(child: EmptyMsgContainer())
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Center(
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            var list = data.where((element) =>
                                                element.date == dates[i]);
                                            List<Transaction> finalList =
                                                List.from(list);
                                            var finalMIncome = 0.0,
                                                finalMExpense = 0.0;
                                            for (int i = 0;
                                                i < finalList.length;
                                                i++) {
                                              finalList[i].category == "Income"
                                                  ? finalMIncome =
                                                      finalMIncome +
                                                          finalList[i].amount
                                                  : finalMExpense =
                                                      finalMExpense +
                                                          finalList[i].amount;
                                            }
                                            return Theme(
                                              data: ThemeData(
                                                dividerColor:
                                                    Colors.transparent,
                                                colorScheme:
                                                    ColorScheme.fromSwatch()
                                                        .copyWith(
                                                            secondary:
                                                                Colors.grey),
                                              ),
                                              child: ExpansionTile(
                                                backgroundColor:
                                                    Colors.transparent,
                                                tilePadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                initiallyExpanded: true,
                                                childrenPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        "${dates[i]}/${data[i].month}/${data[i].year}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        children: [
                                                          finalMIncome == 0.0
                                                              ? Container()
                                                              : Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        AutoSizeText(
                                                                      '+ $finalMIncome',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            8.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          finalMExpense == 0.0
                                                              ? Container()
                                                              : SizedBox(
                                                                  width: 16.0,
                                                                ),
                                                          finalMExpense == 0.0
                                                              ? Container()
                                                              : Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        AutoSizeText(
                                                                      '- $finalMExpense',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            8.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                children: List.generate(
                                                  finalList.length,
                                                  (i) => Column(
                                                    children: [
                                                      Card(
                                                        child: ListTile(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              PageTransition(
                                                                child:
                                                                    TransactionDetailScreen(
                                                                  t: finalList[
                                                                      i],
                                                                  refresh: () {
                                                                    refreshData(
                                                                        data[i]
                                                                            .month,
                                                                        data[i]
                                                                            .year);
                                                                  },
                                                                ),
                                                                type: PageTransitionType
                                                                    .bottomToTop,
                                                                curve: Curves
                                                                    .easeInOut,
                                                              ),
                                                            );
                                                          },
                                                          onLongPress: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              PageTransition(
                                                                child:
                                                                    TransactionUpdateScreen(
                                                                  t: finalList[
                                                                      i],
                                                                  refresh: () {
                                                                    refreshData(
                                                                        data[i]
                                                                            .month,
                                                                        data[i]
                                                                            .year);
                                                                  },
                                                                ),
                                                                type: PageTransitionType
                                                                    .bottomToTop,
                                                                curve: Curves
                                                                    .easeInOut,
                                                              ),
                                                            );
                                                          },
                                                          dense: true,
                                                          title: Text(
                                                            "${finalList[i].name}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15.5,
                                                            ),
                                                          ),
                                                          leading: Image.asset(
                                                            "${finalList[i].imgSrc}",
                                                            height: 28.0,
                                                            width: 28.0,
                                                          ),
                                                          subtitle: finalList[i]
                                                                      .memo ==
                                                                  finalList[i]
                                                                      .name
                                                              ? Text("")
                                                              : Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child:
                                                                      AutoSizeText(
                                                                    "${finalList[i].memo}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          11.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                          trailing: Text(
                                                            finalList[i].category ==
                                                                    "Income"
                                                                ? "${finalList[i].amount}"
                                                                : "- ${finalList[i].amount}",
                                                            style: TextStyle(
                                                              color: finalList[
                                                                              i]
                                                                          .category ==
                                                                      "Income"
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        elevation: 0.4,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          //itemCount: data.length,
                                          itemCount: dates.length,
                                        ),
                                      ),
                                    );
                            }
                          }
                          return getProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: FloatingActionButton(
                      heroTag: 'addNew',
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: NewTransactionScreen(
                              refresh: () {
                                refreshData(
                                    selectedDate1.month, selectedDate1.year);
                                setState(() {
                                  selectedMonth = selectedDate1.month - 1;
                                  currYear = selectedDate1.year;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            type: PageTransitionType.bottomToTop,
                            curve: Curves.easeInOut,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        size: 35.0,
                      ),
                      backgroundColor: kBackColor,
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

  refreshData(int m, int y) {
    setState(() {
      fetchedMainData = dbh.getMainData(m, y);
      fetchedTransactions = dbh.getTransactions(m, y);
    });
  }

  Widget buildDrawer() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo(),
            customTile(
              iconData: Icons.category_rounded,
              string: 'Categories',
              onClick: () {
                drawerKey.currentState.closeDrawer();
                Navigator.of(context).push(
                  PageTransition(
                    child: CategoriesScreen(),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
            ),
            myDivider(),
            customTile(
              iconData: Icons.settings_rounded,
              string: 'Settings',
              onClick: () {
                drawerKey.currentState.closeDrawer();
                Navigator.of(context).push(
                  PageTransition(
                    child: SettingScreen(),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
            ),
            myDivider(),
            customTile(
              iconData: Icons.info_outline_rounded,
              string: 'About',
              onClick: () {
                drawerKey.currentState.closeDrawer();
                Navigator.of(context).push(
                  PageTransition(
                    child: MyAboutTile(),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
            ),
            myDivider(),
            customTile(
              iconData: Icons.share_rounded,
              string: 'Share App',
              onClick: () {},
            ),
            myDivider(),
            customTile(
              iconData: Icons.share_rounded,
              string: 'Reports',
              onClick: () {},
            ),
            myDivider(),
            customTile(
              iconData: Icons.star_rate_rounded,
              string: 'Rate the App',
              onClick: () {},
            ),
            myDivider(),
            customTile(
              iconData: Icons.logout,
              string: 'Log out',
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget customTile({IconData iconData, String string, Function onClick}) {
    return ListTile(
      minLeadingWidth: 5,
      dense: true,
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 10.0,
      selected: true,
      leading: Icon(
        iconData,
        color: Colors.white,
      ),
      onTap: onClick,
      title: Text(string, style: kDrawerTextStyle),
    );
  }

  myDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.35),
      indent: 15,
      height: 45,
      endIndent: 50,
    );
  }

  userInfo() {
    return Container(
      child: FutureBuilder(
        future: fetchedUser,
        builder: (context, ss) {
          if (ss.hasData) {
            if (ss.data != null) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      minRadius: 32.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        minRadius: 60.0,
                        backgroundImage: MemoryImage(ss.data[0].image),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        ss.data[0].name,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              );
            }
          }
          return getProgressIndicator();
        },
      ),
    );
  }
}
