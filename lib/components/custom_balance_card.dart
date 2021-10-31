import 'package:flutter/material.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/screens/chart_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:money_manager/main.dart';

class CustomBalanceCard extends StatefulWidget {
  final MainData data;
  CustomBalanceCard({this.data});
  @override
  _CustomBalanceCardState createState() => _CustomBalanceCardState();
}

class _CustomBalanceCardState extends State<CustomBalanceCard>
    with SingleTickerProviderStateMixin {
  var width;
  var height;
  AnimationController controller;
  Animation scaleAnimation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Row(
          children: [
            myCustomButton(
                click: () {
                  if (widget.data.income == 0.0 && widget.data.expense == 0.0) {
                    Navigator.of(context).push(
                      PageTransition(
                        child: MyChartScreen(
                          month: widget.data.month,
                          year: widget.data.year,
                          category: 'Income',
                          totalAmount: widget.data.income,
                        ),
                        type: PageTransitionType.bottomToTop,
                        curve: Curves.easeInOut,
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      PageTransition(
                        child: MyChartScreen(
                          month: widget.data.month - 1,
                          year: widget.data.year,
                          category: 'Income',
                          totalAmount: widget.data.income,
                        ),
                        type: PageTransitionType.bottomToTop,
                        curve: Curves.easeInOut,
                      ),
                    );
                  }
                },
                amt: widget.data.income == 0.0
                    ? "0"
                    : widget.data.income.toString(),
                title: "Income"),
            SizedBox(
              width: 10,
            ),
            myCustomButton(
                click: () {
                  if (widget.data.income == 0.0 && widget.data.expense == 0.0) {
                    Navigator.of(context).push(
                      PageTransition(
                        child: MyChartScreen(
                          month: widget.data.month,
                          year: widget.data.year,
                          category: 'Expense',
                          totalAmount: widget.data.expense,
                        ),
                        type: PageTransitionType.bottomToTop,
                        curve: Curves.easeInOut,
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      PageTransition(
                        child: MyChartScreen(
                          month: widget.data.month - 1,
                          year: widget.data.year,
                          category: 'Expense',
                          totalAmount: widget.data.expense,
                        ),
                        type: PageTransitionType.bottomToTop,
                        curve: Curves.easeInOut,
                      ),
                    );
                  }
                },
                amt: widget.data.expense == 0.0
                    ? "0"
                    : widget.data.expense.toString(),
                title: "Expense"),
            SizedBox(
              width: 10,
            ),
            myCustomButton(
                click: () {},
                amt: widget.data.balance == 0.0
                    ? "0"
                    : widget.data.balance.toString(),
                title: "Balance"),
          ],
        ),
      ),
    );
  }

  Widget myCustomButton({Function click, String amt, String title}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: click,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0.0),
//          primary: Color(0xfff0f8ff),
          //primary: kBackColor.withOpacity(0.5),
          primary: Colors.grey.shade50,
          elevation: 3.0,
        ),
        child: Container(
          height: height * 0.13,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              AutoSizeText(
                amt,
                overflow: TextOverflow.visible,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 19.5,
                  color: kBackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
