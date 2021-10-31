import 'package:flutter/material.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/helpers/db_helper.dart';
import 'package:money_manager/screens/transaction_update_screen.dart';

class TransactionDetailScreen extends StatefulWidget {
  static const String id = 'transaction_detail_screen';
  final Transaction t;
  final Function refresh;
  TransactionDetailScreen({this.t, this.refresh});
  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: kBackColor,
              ),
              onPressed: () {
                showDeleteDialog();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.mode_edit_rounded,
                color: kBackColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionUpdateScreen()));
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBackColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(
              color: kBackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  height: 35.0,
                                  width: 35.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(widget.t.imgSrc),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.t.name,
                                style: TextStyle(
                                  color: kBackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      myDetailRow(
                        title: "Category",
                        value: widget.t.category,
                      ),
                      myDetailRow(
                        title: "Amount",
                        value: widget.t.amount.toString(),
                      ),
                      myDetailRow(
                        title: "Date",
                        value: widget.t.date.toString() +
                            "/" +
                            widget.t.month.toString() +
                            "/" +
                            widget.t.year.toString(),
                      ),
                      myDetailRow(
                        title: "Description",
                        value: widget.t.memo,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myDetailRow({String title, String value}) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: myTitle(title),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                value,
                style: TextStyle(
                  color: kBackColor.withOpacity(0.9),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget myTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade700.withOpacity(0.6),
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
      ),
    );
  }

  showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Delete",
              style: TextStyle(
                color: kBackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text("Are you sure you want to delete this one ?"),
            contentTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "NO",
                  style: TextStyle(
                    color: kBackColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  var res = await dbh.deleteTransaction(widget.t.id);
                  if (res > 0) {
                    List responses =
                        await dbh.getMainData(widget.t.month, widget.t.year);
                    double finalIncome = widget.t.category == "Income"
                        ? responses[0].income - widget.t.amount
                        : responses[0].income;
                    double finalExpense = widget.t.category == "Expense"
                        ? responses[0].expense - widget.t.amount
                        : responses[0].expense;
                    double finalBalance = finalIncome - finalExpense;
                    MainData m = MainData(
                        income: finalIncome,
                        expense: finalExpense,
                        balance: finalBalance,
                        month: widget.t.month,
                        year: widget.t.year);
                    var isUpdated = await dbh.updateMainData(m);
                    if (isUpdated > 0) {
                      widget.refresh();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      print("Not updated");
                    }
                  } else {
                    print("Not deleted");
                  }
                },
                child: Text(
                  "YES",
                  style: TextStyle(
                    color: kBackColor,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
