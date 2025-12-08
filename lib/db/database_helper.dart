import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'health_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE checkups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        result TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doctor TEXT,
        specialization TEXT,
        date TEXT,
        time TEXT,
        notes TEXT
      )
    ''');
  }

  Future<int> insertCheckup(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('checkups', row);
  }

  Future<int> insertAppointment(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('appointments', row);
  }

  Future<List<Map<String, dynamic>>> getCheckups() async {
    Database db = await database;
    return await db.query('checkups', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    Database db = await database;
    return await db.query('appointments', orderBy: 'id DESC');
  }

  Future<int> deleteAllCheckups() async {
    Database db = await database;
    return await db.delete('checkups');
  }

  Future<int> deleteAllAppointments() async {
    Database db = await database;
    return await db.delete('appointments');
  }
}
