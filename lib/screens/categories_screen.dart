import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_manager/components/category_item_button.dart';
import 'package:money_manager/models/expense_item_model.dart';
import 'package:money_manager/models/income_item_model.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:money_manager/helpers/db_helper.dart';
//import 'package:money_manager/main.dart';

class CategoriesScreen extends StatefulWidget {
  static const String id = 'categories_screen';
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  List customCategoryItems = [
    'assets/categories/custom/custom_blue.png',
    'assets/categories/custom/custom_indigo.png',
    'assets/categories/custom/custom_orange.png',
    'assets/categories/custom/custom_purple.png',
    'assets/categories/custom/custom_red.png',
    'assets/categories/custom/custom_teal.png',
    'assets/categories/custom/custom_yellow.png',
  ];

  bool isIncomeCatSelected = false;
  int selectedCatIndex1;
  int selectedCatIndex2;
  GlobalKey<FormState> addNewIncomeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addNewExpenseFormKey = GlobalKey<FormState>();
  TextEditingController newIncomeController = TextEditingController();
  TextEditingController newExpenseController = TextEditingController();

  BuildContext buildContext1;
  BuildContext buildContext2;
  Future fetchedIncomes;
  Future fetchedExpenses;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    fetchedIncomes = dbh.getIncomes();
    fetchedExpenses = dbh.getExpenses();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext1 = context;
    buildContext2 = context;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        backgroundColor: kBackColor,
        onPressed: () {
          _tabController.index == 0
              ? showAddCategoryBottomSheet(
                  buildContext1,
                  addNewIncomeFormKey,
                  "Add New Income Category",
                  selectedCatIndex1,
                  newIncomeController,
                )
              : showAddCategoryBottomSheet(
                  buildContext2,
                  addNewExpenseFormKey,
                  "Add New Expense Category",
                  selectedCatIndex2,
                  newExpenseController,
                );
        },
      ),
      appBar: AppBar(
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
        elevation: 0.0,
        title: Text(
          "Categories",
          style: TextStyle(
            color: kBackColor,
          ),
        ),
        bottom: TabBar(
          indicatorColor: kBackColor,
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "Income",
                style: TextStyle(
                  color: kBackColor,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Expense",
                style: TextStyle(
                  color: kBackColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: FutureBuilder(
              future: fetchedIncomes,
              builder: (context, ss) {
                if (ss.hasData) {
                  if (ss.data != null) {
                    var incomes = ss.data;
                    return GridView.builder(
                        itemCount: incomes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) => CategoryItemButton(
                              click: () {},
                              longClick: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blueGrey,
                                    elevation: 6.0,
                                    margin: EdgeInsets.all(20),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    content: Text(
                                      "Are you sure you really want to delete ${incomes[index].name} category ?",
                                    ),
                                    action: SnackBarAction(
                                      textColor: Colors.red,
                                      label: "YES",
                                      onPressed: () async {
                                        var res = await dbh
                                            .deleteIncomeCategory(index + 1);
                                        if (res > 0) {
                                          refresh();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                elevation: 6.0,
                                                margin: EdgeInsets.all(20),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                content:
                                                    Text("Deleted Successfully"
                                                        "✔")),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              item: incomes[index].name,
                              image: incomes[index].img,
                            ));
                  }
                }
                return Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                );
              },
            ),
          ),
          Container(
            child: FutureBuilder(
              future: fetchedExpenses,
              builder: (context, ss) {
                if (ss.hasData) {
                  if (ss.data != null) {
                    var expenses = ss.data;
                    return GridView.builder(
                        itemCount: expenses.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) => CategoryItemButton(
                              click: () {},
                              longClick: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blueGrey,
                                    elevation: 6.0,
                                    margin: EdgeInsets.all(20),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    content: Text(
                                      "Are you sure you really want to delete  ${expenses[index].name}  category ?",
                                    ),
                                    action: SnackBarAction(
                                      textColor: Colors.red,
                                      label: "YES",
                                      onPressed: () async {
                                        var res = await dbh
                                            .deleteExpenseCategory(index + 1);
                                        if (res > 0) {
                                          refresh();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                elevation: 6.0,
                                                margin: EdgeInsets.all(20),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                content: Text(
                                                    "Deleted Successfully")),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              item: expenses[index].name,
                              image: expenses[index].img,
                            ));
                  }
                }
                return Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void refresh() {
    setState(() {
      fetchedIncomes = dbh.getIncomes();
      fetchedExpenses = dbh.getExpenses();
    });
  }

  showAddCategoryBottomSheet(BuildContext context, Key key, String title,
      int selected, var controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Form(
              key: key,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          customCategoryItems.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: selected == index
                                    ? kBackColor.withOpacity(0.20)
                                    : Colors.transparent,
                              ),
                              onPressed: () {
                                setState(() {
                                  selected = index;
                                });
                              },
                              child: Image.asset(
                                customCategoryItems[index],
                                height: 50.0,
                                width: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Category name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            controller.clear();
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
                          onPressed: () async {
                            if (selected != null && controller.text != "") {
                              //it means category icon and name is selected
                              if (title.contains("Income")) {
                                //it means it is income category
                                IncomeItem item = IncomeItem(
                                    name: controller.text,
                                    img: customCategoryItems[selected]);
                                var res = await dbh.addIncomeCategory(item);
                                if (res > 0) {
                                  refresh();
                                  Navigator.of(context).pop();
                                }
                              } else {
                                ExpenseItem item = ExpenseItem(
                                    name: controller.text,
                                    img: customCategoryItems[selected]);
                                var res = await dbh.addExpenseCategory(item);
                                if (res > 0) {
                                  refresh();
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.green,
                          ),
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          label: Text(
                            "ADD",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
