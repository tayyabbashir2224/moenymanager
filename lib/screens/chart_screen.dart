import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/utils/get_progress_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:money_manager/helpers/db_helper.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyChartScreen extends StatefulWidget {
  final int month;
  final int year;
  final String category;
  final double totalAmount;
  MyChartScreen({this.month, this.year, this.category, this.totalAmount});

  @override
  _MyChartScreenState createState() => _MyChartScreenState();
}

class _MyChartScreenState extends State<MyChartScreen> {
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future fetchedData;
  List finalData = [];
  List finalAmount = [];
  List<double> chartPercentages = <double>[];
  List<double> listPercentages = <double>[];

  Map<String, double> dataMap = Map();

  @override
  void initState() {
    currMonthIndex = widget.month;
    currYear = widget.year;
    tempYear = widget.year;
    tempMonthIndex = widget.month;
    fetchedData = dbh.getTransactionsByCategory(
        currMonthIndex + 1, currYear, widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: kBackColor.withOpacity(0.15),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBackColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      color: kBackColor,
                      fontSize: 10.0,
                    ),
                  ),
                  Text(
                    widget.totalAmount.toString(),
                    style: TextStyle(
                      color: kBackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            )
          ],
          centerTitle: true,
          title: Text(
            months[currMonthIndex],
            style: TextStyle(
              color: kBackColor,
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
        ),
        body: FutureBuilder(
          future: fetchedData,
          builder: (context, ss) {
            if (ss.hasData) {
              if (ss.data != null) {
                if (ss.data.length != 0) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: kBackColor.withOpacity(0.4),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: FutureBuilder(
                                  future: fetchedData,
                                  builder: (context, ss) {
                                    if (ss.hasData) {
                                      if (ss.data != null) {
                                        var data = ss.data;
                                        //sort transactions based on amount
                                        sortData(data);
                                        double totalAmt = 0.0;
                                        if (data.length != 0) {
                                          for (int i = 0;
                                              i < data.length;
                                              i++) {
                                            if (dataMap
                                                .containsKey(data[i].name)) {
                                              dataMap[data[i].name] =
                                                  data[i].amount +
                                                      dataMap[data[i].name];
                                            } else {
                                              dataMap[data[i].name] =
                                                  data[i].amount;
                                            }
                                          }
                                          var sortedKeys = dataMap.keys
                                              .toList(growable: false)
                                                ..sort((k2, k1) => dataMap[k1]
                                                    .compareTo(dataMap[k2]));

                                          LinkedHashMap sortedMap =
                                              new LinkedHashMap.fromIterable(
                                                  sortedKeys,
                                                  key: (k) => k,
                                                  value: (k) => dataMap[k]);

                                          for (double value
                                              in sortedMap.values) {
                                            totalAmt = totalAmt + value;
                                          }
                                          for (double values
                                              in sortedMap.values) {
                                            double per =
                                                (values * 100) / totalAmt;
                                            chartPercentages.add(double.parse(
                                                per.toStringAsFixed(1)));
                                          }
                                          dataMap = Map<String, double>.from(
                                              sortedMap);
                                          double newAmt = 0.0;
                                          if (dataMap.length > 5) {
                                            for (int j = 4;
                                                j < dataMap.length;
                                                j++) {
                                              newAmt = newAmt +
                                                  dataMap.values.elementAt(j);
                                            }

                                            var keysToBeDeleted = [];
                                            for (int i = 4;
                                                i < dataMap.length;
                                                i++) {
                                              keysToBeDeleted.add(
                                                  dataMap.keys.elementAt(i));
                                            }
                                            for (int k = 0;
                                                k < keysToBeDeleted.length;
                                                k++) {
                                              dataMap
                                                  .remove(keysToBeDeleted[k]);
                                            }
                                            dataMap['Others...'] = newAmt;
                                          }
                                        }
                                        return PieChart(
                                          dataMap: dataMap,
                                          chartLegendSpacing: 60,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.5,
                                          colorList: [
                                            Color(0xFF1B54A9),
                                            Colors.amber.shade500,
                                            Colors.green.shade500,
                                            Colors.red.shade500,
                                            Colors.tealAccent.shade400,
                                          ],
                                          initialAngleInDegree: 0,
                                          chartType: ChartType.ring,
                                          ringStrokeWidth: 15,
                                          centerText: widget.category,
                                          emptyColor: Colors.grey,
                                          legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: true,
                                            legendShape: BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            showChartValueBackground: false,
                                            showChartValues: true,
                                            showChartValuesInPercentage: true,
                                            showChartValuesOutside: true,
                                            decimalPlaces: 1,
                                          ),
                                        );
                                      }
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: fetchedData,
                        builder: (context, ss) {
                          if (ss.hasData) {
                            if (ss.data != null) {
                              var data = ss.data;
                              double totalAmt = 0.0;
                              Map<String, double> dataMap2 = Map();
                              if (data.length != 0) {
                                sortData(data);
                                for (int i = 0; i < data.length; i++) {
                                  if (dataMap2.containsKey(data[i].name)) {
                                    dataMap2[data[i].name] =
                                        data[i].amount + dataMap2[data[i].name];
                                  } else {
                                    dataMap2[data[i].name] = data[i].amount;
                                  }
                                }
                                var sortedKeys = dataMap2.keys
                                    .toList(growable: false)
                                      ..sort((k2, k1) =>
                                          dataMap2[k1].compareTo(dataMap2[k2]));

                                LinkedHashMap sortedMap =
                                    new LinkedHashMap.fromIterable(sortedKeys,
                                        key: (k) => k,
                                        value: (k) => dataMap2[k]);

                                for (String key in sortedMap.keys) {
                                  for (int j = 0; j < data.length; j++) {
                                    if (key == data[j].name) {
                                      finalAmount.add(sortedMap[key]);
                                      totalAmt = totalAmt + sortedMap[key];
                                      finalData.add(data[j]);
                                      break;
                                    }
                                  }
                                }
                                for (double values in sortedMap.values) {
                                  double per = (values * 100) / totalAmt;
                                  listPercentages.add(
                                      double.parse(per.toStringAsFixed(1)));
                                }
                                finalAmount.sort((b, a) => a.compareTo(b));
                                listPercentages.sort((b, a) => a.compareTo(b));
                              }

                              return Expanded(
                                flex: 2,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 10.0),
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: kBackColor.withOpacity(0.4),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 18.0,
                                                right: 18.0,
                                                top: 18.0,
                                                bottom: 8.0,
                                              ),
                                              child: Text(
                                                widget.category == "Income"
                                                    ? "Income List"
                                                    : "Expense List",
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: CupertinoScrollbar(
                                                child: ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  children: List.generate(
                                                    dataMap2.length,
                                                    (i) => getCustomTile(
                                                        finalData[i],
                                                        listPercentages[i],
                                                        finalAmount[i]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return getProgressIndicator();
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nothing_found.png',
                          color: kBackColor.withOpacity(0.5),
                          height: 65.0,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "No data Available...",
                          style: TextStyle(
                            color: kBackColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
            return getProgressIndicator();
          },
        ),
      ),
    );
  }

  sortData(var data) {
    var temp;
    for (int i = 0; i < data.length; i++) {
      for (int j = i + 1; j < data.length; j++) {
        if (data[i].amount < data[j].amount) {
          temp = data[j];
          data[j] = data[i];
          data[i] = temp;
        }
      }
    }
  }

  Widget getCustomTile(Transaction t, double per, double amt) {
    return Column(
      children: [
        Container(
          height: 40.0,
          child: Row(
            children: [
              Expanded(
                child: Image.asset(
                  t.imgSrc,
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Text("${t.name} $per"),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                text: '${t.name}',
                              ),
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                ),
                                text: '    $per %',
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: Text(
                            '$amt',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    LinearPercentIndicator(
                      padding: EdgeInsets.all(2.0),
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      width: MediaQuery.of(context).size.width * 0.55,
                      lineHeight: 5.0,
                      percent: per / 100.0,
                      progressColor: kBackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Divider(
            indent: 15.0,
            endIndent: 15.0,
          ),
        ),
      ],
    );
  }

  int currMonthIndex;
  int currYear;
  int tempYear;
  int tempMonthIndex;
}
