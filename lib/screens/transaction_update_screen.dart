import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/helpers/db_helper.dart';

class TransactionUpdateScreen extends StatefulWidget {
  static const String id = 'transaction_detail_screen';
  final Transaction t;
  final Function refresh;
  TransactionUpdateScreen({@required this.t, this.refresh});
  @override
  _TransactionUpdateScreenState createState() =>
      _TransactionUpdateScreenState();
}

class _TransactionUpdateScreenState extends State<TransactionUpdateScreen> {
  var dropDownVal;
  TextEditingController amountController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  DateTime finalDate;
  DateTime tempDate;
  @override
  void initState() {
    dropDownVal = widget.t.category;
    amountController.text = widget.t.amount.toString();
    memoController.text = widget.t.memo;
    finalDate = DateTime(widget.t.year, widget.t.month, widget.t.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        //backgroundColor: Colors.blue.shade50,
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
            "Update Transaction",
            style: TextStyle(
              color: kBackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Form(
          key: updateFormKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: myTitle("Category")),
                                  Expanded(
                                    child: Text(
                                      widget.t.category,
                                      style: TextStyle(
                                        color: kBackColor.withOpacity(0.9),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: myTitle("Amount"),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: amountController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "* required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        color: kBackColor.withOpacity(0.9),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: myTitle("Date"),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(0.0),
                                        elevation: 0.0,
                                        primary: Colors.grey.shade50,
                                      ),
                                      onPressed: () {
                                        showMyDatePicker();
                                      },
                                      child: Text(
                                        finalDate.day.toString() +
                                            "/" +
                                            finalDate.month.toString() +
                                            "/" +
                                            finalDate.year.toString(),
                                        style: TextStyle(
                                          color: kBackColor.withOpacity(0.9),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: myTitle("Description"),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 10,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "* required";
                                        }
                                        return null;
                                      },
                                      controller: memoController,
                                      style: TextStyle(
                                        color: kBackColor.withOpacity(0.9),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () async {
                          if (updateFormKey.currentState.validate()) {
                            if (widget.t.amount.toString() ==
                                    amountController.text &&
                                widget.t.date == finalDate.day &&
                                widget.t.month == finalDate.month &&
                                widget.t.year == finalDate.year &&
                                widget.t.memo == memoController.text) {
                              print("Not Changed");
                              Navigator.of(context).pop();
                            } else {
                              updateMyTransaction();
                            }
                          }
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                            color: kBackColor,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      "assets/images/double_arrow.png"),
                                ),
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
      ),
    );
  }

  updateMyTransaction() async {
    print(widget.t.amount);
    print(amountController.text);
    print(widget.t.memo);
    print(memoController.text);
    print("changed");
    var res = await dbh.updateTransaction(
      memo: memoController.text,
      amt: double.parse(amountController.text),
      d: finalDate.day,
      m: finalDate.month,
      y: finalDate.year,
      id: widget.t.id,
    );
    if (res > 0) {
      if (widget.t.amount == double.parse(amountController.text)) {
        //only date is changed
        if (widget.t.month != finalDate.month ||
            widget.t.year != finalDate.year) {
          //if only month or year changed
          //previous month/year
          MainData m, updatedM;
          List responses = await dbh.getMainData(widget.t.month, widget.t.year);
          double finalIncome = widget.t.category == "Income"
              ? (responses[0].income - widget.t.amount)
              : responses[0].income;
          double finalExpense = widget.t.category == "Expense"
              ? (responses[0].expense - widget.t.amount)
              : responses[0].expense;
          double finalBalance = finalIncome - finalExpense;
          m = MainData(
            income: finalIncome,
            expense: finalExpense,
            balance: finalBalance,
            month: widget.t.month,
            year: widget.t.year,
          );

          //new month/year
          List responses2 =
              await dbh.getMainData(finalDate.month, finalDate.year);
          double finalIncome2;
          double finalExpense2;
          double finalBalance2;
          if (responses2.length == 0) {
            var check = await dbh.addMainData(MainData(
                income: 0.0,
                expense: 0.0,
                balance: 0.0,
                month: finalDate.month,
                year: finalDate.year));
            if (check > 0) {
              finalIncome2 =
                  widget.t.category == "Income" ? (0.0 + widget.t.amount) : 0.0;
              finalExpense2 = widget.t.category == "Expense"
                  ? (0.0 + widget.t.amount)
                  : 0.0;
              finalBalance2 = finalIncome2 - finalExpense2;
            }
          } else {
            finalIncome2 = widget.t.category == "Income"
                ? (responses2[0].income + widget.t.amount)
                : responses2[0].income;
            finalExpense2 = widget.t.category == "Expense"
                ? (responses2[0].expense + widget.t.amount)
                : responses2[0].expense;
            finalBalance2 = finalIncome2 - finalExpense2;
          }

          updatedM = MainData(
            income: finalIncome2,
            expense: finalExpense2,
            balance: finalBalance2,
            month: finalDate.month,
            year: finalDate.year,
          );
          var res = await dbh.updateMainData(m);
          var res2 = await dbh.updateMainData(updatedM);
          if (res > 0 && res2 > 0) {
            widget.refresh();
            Navigator.of(context).pop();
          }
        } else {
          //ony date is changed month and year are same
          widget.refresh();
          Navigator.of(context).pop();
        }
      } else if (widget.t.amount != double.parse(amountController.text) &&
          (widget.t.month == finalDate.month &&
              widget.t.year == finalDate.year)) {
        //only amount is changed
        //working
        MainData m;
        List responses = await dbh.getMainData(widget.t.month, widget.t.year);
        double finalIncome = widget.t.category == "Income"
            ? (responses[0].income - widget.t.amount) +
                double.parse(amountController.text)
            : responses[0].income;
        double finalExpense = widget.t.category == "Expense"
            ? (responses[0].expense - widget.t.amount) +
                double.parse(amountController.text)
            : responses[0].expense;
        double finalBalance = finalIncome - finalExpense;
        m = MainData(
          income: finalIncome,
          expense: finalExpense,
          balance: finalBalance,
          month: widget.t.month,
          year: widget.t.year,
        );
        var res = await dbh.updateMainData(m);
        if (res > 0) {
          widget.refresh();
          Navigator.of(context).pop();
        }
      } else {
        //both are changed (amount,month,year)
        //works perfectly
        MainData updatedM, m;
        List responses = await dbh.getMainData(widget.t.month, widget.t.year);
        double finalIncome = widget.t.category == "Income"
            ? (responses[0].income - widget.t.amount)
            : responses[0].income;
        double finalExpense = widget.t.category == "Expense"
            ? (responses[0].expense - widget.t.amount)
            : responses[0].expense;
        double finalBalance = finalIncome - finalExpense;
        m = MainData(
          income: finalIncome,
          expense: finalExpense,
          balance: finalBalance,
          month: widget.t.month,
          year: widget.t.year,
        );
        List responses2 =
            await dbh.getMainData(finalDate.month, finalDate.year);
        double finalIncome2, finalExpense2, finalBalance2;
        print("response length is he ${responses2.length}");
        if (responses2.length == 0) {
          var check = await dbh.addMainData(MainData(
              income: 0.0,
              expense: 0.0,
              balance: 0.0,
              month: finalDate.month,
              year: finalDate.year));
          if (check > 0) {
            finalIncome2 = widget.t.category == "Income"
                ? (0.0 + double.parse(amountController.text))
                : 0.0;
            finalExpense2 = widget.t.category == "Expense"
                ? (0.0 + double.parse(amountController.text))
                : 0.0;
            finalBalance2 = finalIncome2 - finalExpense2;
            print(finalIncome2);
            print(finalExpense2);
            print(finalBalance2);
          }
        } else {
          finalIncome2 = widget.t.category == "Income"
              ? (responses2[0].income + double.parse(amountController.text))
              : responses2[0].income;
          finalExpense2 = widget.t.category == "Expense"
              ? (responses2[0].expense + double.parse(amountController.text))
              : responses2[0].expense;
          finalBalance2 = finalIncome2 - finalExpense2;
        }
        updatedM = MainData(
          income: finalIncome2,
          expense: finalExpense2,
          balance: finalBalance2,
          month: finalDate.month,
          year: finalDate.year,
        );
        var res = await dbh.updateMainData(m);
        var res2 = await dbh.updateMainData(updatedM);
        if (res > 0 && res2 > 0) {
          widget.refresh();
          Navigator.of(context).pop();
        }
      }
    }
  }

  showMyDatePicker() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (val) {
                    setState(() {
                      tempDate = val;
                    });
                  },
                  initialDateTime: finalDate,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      label: Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          finalDate = tempDate;
                          Navigator.of(context).pop();
                        });
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.green,
                      ),
                      label: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        );
      },
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
          fontSize: 14.5,
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
