import 'package:money_manager/models/expense_item_model.dart';
import 'package:money_manager/models/income_item_model.dart';
import 'package:money_manager/models/main_data_model.dart';
import 'package:money_manager/models/transaction_model.dart' as appTransaction;
import 'package:money_manager/models/user_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database db;
  static String path;
  final String expenseTB = "expenseTB";
  final String incomeTB = "incomeTB";
  final String mainDataTB = "mainDataTB";
  final String transactionTB = "transactionTB";
  final String userTB = "userTB";

  DBHelper._();

  Future<Database> initDB() async {
    if (db != null) {
      return db;
    } else {
      path = join(await getDatabasesPath(), 'mm.db');
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, ver) async => await populateDB(db),
      );
      return db;
    }
  }

  populateDB(Database db) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $userTB(name TEXT,gender TEXT,date INTEGER,month INTEGER,year INTEGER,image BLOB)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $expenseTB (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,imgPath TEXT)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $incomeTB (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,imgPath TEXT)");
    for (int i = 0; i < expenses.length; i++) {
      List args = ['${expenses[i].name}', '${expenses[i].img}'];
      await db.rawInsert(
          "INSERT INTO $expenseTB (name,imgPath) VALUES(?,?)", args);
    }
    for (int i = 0; i < incomes.length; i++) {
      List args = ['${incomes[i].name}', '${incomes[i].img}'];
      await db.rawInsert(
          "INSERT INTO $incomeTB (name,imgPath) VALUES(?,?)", args);
    }
    await db.execute(
        "CREATE TABLE $mainDataTB (income REAL,expense REAL,balance REAL,month INTEGER,year INTEGER)");
    await db.execute(
        "CREATE TABLE $transactionTB (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,category TEXT,amount REAL,memo TEXT,date INTEGER,month INTEGER,year INTEGER,imgSrc TEXT)");
  }

  Future<List<IncomeItem>> getIncomes() async {
    await initDB();
    String query = "SELECT * FROM $incomeTB";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => IncomeItem(
        id: res[i]['id'],
        name: res[i]['name'],
        img: res[i]['imgPath'],
      ),
    );
  }

  Future<int> addIncomeCategory(IncomeItem item) async {
    String query = "INSERT INTO $incomeTB (name,imgPath) VALUES(?,?)";
    List args = ['${item.name}', '${item.img}'];
    var res = await db.rawInsert(query, args);
    return res;
  }

  Future<int> deleteIncomeCategory(int id) async {
    String query = "DELETE FROM $incomeTB WHERE id=$id";
    var res = await db.rawDelete(query);
    return res;
  }

  Future<List<ExpenseItem>> getExpenses() async {
    await initDB();
    String query = "SELECT * FROM $expenseTB";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => ExpenseItem(
        id: res[i]['id'],
        name: res[i]['name'],
        img: res[i]['imgPath'],
      ),
    );
  }

  Future<int> addExpenseCategory(ExpenseItem item) async {
    String query = "INSERT INTO $expenseTB (name,imgPath) VALUES(?,?)";
    List args = ['${item.name}', '${item.img}'];
    var res = await db.rawInsert(query, args);
    return res;
  }

  Future<int> deleteExpenseCategory(int id) async {
    String query = "DELETE FROM $expenseTB WHERE id=$id";
    var res = await db.rawDelete(query);
    return res;
  }

  Future<int> insertUserDetail(User user) async {
    await initDB();
    String query =
        "INSERT INTO $userTB (name,gender,date,month,year,image) VALUES(?,?,?,?,?,?)";
    List args = [
      '${user.name}',
      '${user.gender}',
      user.date,
      user.month,
      user.year,
      user.image,
    ];
    var res = await db.rawInsert(query, args);
    return res;
  }

  Future<List<User>> getUserDetail() async {
    await initDB();
    String query = "SELECT * FROM $userTB";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => User(
        name: res[0]['name'],
        gender: res[0]['gender'],
        date: res[0]['date'],
        month: res[0]['month'],
        year: res[0]['year'],
        image: res[0]['image'],
      ),
    );
  }

  Future<List<MainData>> getMainData(int month, int year) async {
    await initDB();
    String query =
        "SELECT * FROM $mainDataTB WHERE month=$month AND year=$year";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => MainData(
        income: res[i]['income'],
        expense: res[i]['expense'],
        balance: res[i]['balance'],
        month: res[i]['month'],
        year: res[i]['year'],
      ),
    );
  }

  Future<int> updateMainData(MainData m) async {
    String query =
        "UPDATE $mainDataTB SET income=${m.income},expense=${m.expense},balance=${m.balance} WHERE month=${m.month} AND year=${m.year}";
    var res = await db.rawUpdate(query);
    return res;
  }

  Future<int> addMainData(MainData m) async {
    String query =
        "INSERT INTO $mainDataTB (income,expense,balance,month,year) VALUES(?,?,?,?,?)";
    List args = [m.income, m.expense, m.balance, m.month, m.year];
    var res = await db.rawInsert(query, args);
    return res;
  }

  Future<int> addTransaction(appTransaction.Transaction t) async {
    String query =
        "INSERT INTO $transactionTB (name,category,amount,memo,date,month,year,imgSrc) VALUES (?,?,?,?,?,?,?,?)";
    List args = [
      '${t.name}',
      '${t.category}',
      t.amount,
      '${t.memo}',
      t.date,
      t.month,
      t.year,
      '${t.imgSrc}',
    ];
    var res = await db.rawInsert(query, args);
    return res;
  }

  Future<List<appTransaction.Transaction>> getTransactions(
      int month, int year) async {
    await initDB();
    String query =
        "SELECT * FROM $transactionTB WHERE month=$month AND year=$year";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => appTransaction.Transaction(
        id: res[i]['id'],
        name: res[i]['name'],
        category: res[i]['category'],
        amount: res[i]['amount'],
        date: res[i]['date'],
        month: res[i]['month'],
        year: res[i]['year'],
        memo: res[i]['memo'],
        imgSrc: res[i]['imgSrc'],
      ),
    );
  }

  Future<List<appTransaction.Transaction>> getTransactionsByCategory(
      int month, int year, String category) async {
    await initDB();
    String query =
        "SELECT * FROM $transactionTB WHERE month=$month AND year=$year AND category='$category'";
    List<Map<String, dynamic>> res = await db.rawQuery(query);
    return List.generate(
      res.length,
      (i) => appTransaction.Transaction(
        id: res[i]['id'],
        name: res[i]['name'],
        category: res[i]['category'],
        amount: res[i]['amount'],
        date: res[i]['date'],
        month: res[i]['month'],
        year: res[i]['year'],
        memo: res[i]['memo'],
        imgSrc: res[i]['imgSrc'],
      ),
    );
  }

  Future<int> deleteTransaction(int id) async {
    await initDB();
    String query = "DELETE FROM $transactionTB WHERE id=?";
    return await db.rawDelete(query, [id]);
  }

  Future<int> updateTransaction(
      {double amt, int d, int m, int y, String memo, int id}) async {
    await initDB();
    String query =
        "UPDATE $transactionTB SET amount=$amt ,date=$d ,month=$m,year=$y,memo='$memo' where id=$id";
    var res = await db.rawUpdate(query);
    return res;
  }
}

DBHelper dbh = DBHelper._();
