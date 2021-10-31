import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/helpers/db_helper.dart';

DateTime selectedDate1;

class NewTransactionScreen extends StatefulWidget {
  static const id = 'newTransaction_screen';
  final Function refresh;
  NewTransactionScreen({this.refresh});
  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  int selectedValue = 0; //0 for income and 1 for expense
  int imgIndexForCalculator1 = 0;
  int imgIndexForCalculator2 = 0;

  TextEditingController memoController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  GlobalKey<FormState> newTransactionFormKey = GlobalKey<FormState>();
  Future fetchedIncome;
  Future fetchedExpense;

  String memo = "";
  double amount = 0.0;

  DateTime tempDate = DateTime.now();
  DateTime finalDate = DateTime.now();

  List allMonths = [
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

  var allIncomes;
  var allExpenses;

  @override
  void initState() {
    fetchedIncome = dbh.getIncomes();
    fetchedExpense = dbh.getExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add New Transaction",
          style: TextStyle(
            color: kBackColor,
          ),
        ),
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
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 70.0,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSegmentedControl(
                        borderColor: kBackColor,
                        children: {
                          0: Container(
                            decoration: BoxDecoration(
                              color: selectedValue == 0
                                  ? kBackColor
                                  : Colors.white,
                              border: Border.all(
                                color: kBackColor,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "INCOME",
                                style: TextStyle(
                                  color: selectedValue == 0
                                      ? Colors.white
                                      : kBackColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                          ),
                          1: Container(
                            decoration: BoxDecoration(
                              color: selectedValue == 1
                                  ? kBackColor
                                  : Colors.white,
                              border: Border.all(
                                color: kBackColor,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "EXPENSE",
                                style: TextStyle(
                                  color: selectedValue == 1
                                      ? Colors.white
                                      : kBackColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                          ),
                        },
                        onValueChanged: (val) {
                          setState(() {
                            selectedValue = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              selectedValue == 0
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 90.0,
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: fetchedIncome,
                          builder: (context, ss) {
                            if (ss.hasData) {
                              if (ss.data != null) {
                                allIncomes = ss.data;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imgIndexForCalculator1 = i;
                                        });
                                      },
                                      child: Container(
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color: imgIndexForCalculator1 == i
                                              ? kBackColor.withOpacity(0.1)
                                              : Colors.transparent,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              allIncomes[i].img,
                                              height: 30.0,
                                              width: 30.0,
                                            ),
                                            SizedBox(
                                              height: 12.0,
                                            ),
                                            AutoSizeText(
                                              allIncomes[i].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: allIncomes.length,
                                );
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 90.0,
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: fetchedExpense,
                          builder: (context, ss) {
                            if (ss.hasData) {
                              if (ss.data != null) {
                                allExpenses = ss.data;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imgIndexForCalculator2 = i;
                                        });
                                      },
                                      child: Container(
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color: imgIndexForCalculator2 == i
                                              ? kBackColor.withOpacity(0.1)
                                              : Colors.transparent,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              allExpenses[i].img,
                                              height: 30.0,
                                              width: 30.0,
                                            ),
                                            SizedBox(
                                              height: 12.0,
                                            ),
                                            AutoSizeText(
                                              allExpenses[i].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: allExpenses.length,
                                );
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
              Form(
                key: newTransactionFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: TextFormField(
                        controller: memoController,
                        cursorColor: kBackColor,
                        onSaved: (val) {
                          setState(() {
                            memo = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Description (optional)",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: TextFormField(
                        controller: amountController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "* Required";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow((RegExp("[.0-9]"))),
                        ],
                        onSaved: (val) {
                          setState(() {
                            amount = double.parse(val.trim());
                          });
                        },
                        cursorColor: kBackColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Amount",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            selectedValue == 0 ? Icons.add : Icons.remove,
                            color: kBackColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: GestureDetector(
                        onTap: showMyDatePicker,
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelText:
                                "${allMonths[finalDate.month - 1]} ${finalDate.day}, ${finalDate.year}",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 15.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (newTransactionFormKey.currentState.validate()) {
                            newTransactionFormKey.currentState.save();
                            checkAllOk();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kBackColor,
                          padding: EdgeInsets.all(0.0),
                        ),
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ADD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/double_arrow.png',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                  maximumDate: DateTime.now(),
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

  checkAllOk() async {
    if (memo == "") {
      memo = selectedValue == 0
          ? allIncomes[imgIndexForCalculator1].name
          : allExpenses[imgIndexForCalculator2].name;
    }

    Transaction t = new Transaction(
      name: selectedValue == 0
          ? allIncomes[imgIndexForCalculator1].name
          : allExpenses[imgIndexForCalculator2].name,
      category: selectedValue == 0 ? "Income" : "Expense",
      amount: amount,
      memo: memo,
      date: finalDate.day,
      month: finalDate.month,
      year: finalDate.year,
      imgSrc: selectedValue == 0
          ? allIncomes[imgIndexForCalculator1].img
          : allExpenses[imgIndexForCalculator2].img,
    );
    var res = await dbh.addTransaction(t);
    if (res > 0) {
      selectedDate1 = finalDate;
      MainData m;
      List lres = await dbh.getMainData(t.month, t.year);
      if (lres.length == 0) {
        double balance = selectedValue == 0 ? (t.amount - 0) : (0 - t.amount);
        m = MainData(
          income: selectedValue == 0 ? t.amount : 0,
          expense: selectedValue == 1 ? t.amount : 0,
          balance: balance,
          month: t.month,
          year: t.year,
        );
        var res2 = await dbh.addMainData(m);
        if (res2 > 0) {
          widget.refresh();
        }
      } else {
        var income = lres[0].income;
        var expense = lres[0].expense;
        var balance = lres[0].balance;
        m = MainData(
            income: selectedValue == 0 ? income + t.amount : income,
            expense: selectedValue == 1 ? expense + t.amount : expense,
            balance:
                selectedValue == 0 ? balance + t.amount : balance - t.amount,
            month: t.month,
            year: t.year);
        var res2 = await dbh.updateMainData(m);
        if (res2 > 0) {
          widget.refresh();
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Transaction is not added")));
    }
  }
}
