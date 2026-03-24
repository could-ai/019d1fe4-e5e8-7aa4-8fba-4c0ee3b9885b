import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meet_silver.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        city TEXT NOT NULL,
        invoiceNo TEXT NOT NULL,
        date TEXT NOT NULL,
        items TEXT NOT NULL,
        totalFine REAL NOT NULL,
        totalAmount REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        fineReceived REAL NOT NULL,
        cashReceived REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        name TEXT PRIMARY KEY,
        city TEXT NOT NULL,
        totalFineDue REAL NOT NULL,
        totalCashDue REAL NOT NULL
      )
    ''');
  }

  Future<void> initDatabase() async {
    await database;
  }

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await instance.database;
    return await db.insert('invoices', invoice.toMap());
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await instance.database;
    return await db.update('invoices', invoice.toMap(), where: 'id = ?', whereArgs: [invoice.id]);
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await instance.database;
    final result = await db.query('invoices');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<int> insertPayment(Payment payment) async {
    final db = await instance.database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<Customer>> getAllCustomers() async {
    // Simplified: calculate from invoices and payments
    final db = await instance.database;
    final invoices = await getAllInvoices();
    final payments = await db.query('payments');
    Map<String, Customer> customerMap = {};

    for (var invoice in invoices) {
      if (!customerMap.containsKey(invoice.customerName)) {
        customerMap[invoice.customerName] = Customer(name: invoice.customerName, city: invoice.city);
      }
      customerMap[invoice.customerName]!.totalFineDue += invoice.totalFine;
      customerMap[invoice.customerName]!.totalCashDue += invoice.totalAmount;
    }

    for (var payment in payments) {
      if (customerMap.containsKey(payment['customerName'])) {
        customerMap[payment['customerName']]!.totalFineDue -= payment['fineReceived'] as double;
        customerMap[payment['customerName']]!.totalCashDue -= payment['cashReceived'] as double;
      }
    }

    return customerMap.values.toList();
  }
}