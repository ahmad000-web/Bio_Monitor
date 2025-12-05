import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  // Singleton pattern
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
    // Create checkups table
    await db.execute('''
      CREATE TABLE checkups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        result TEXT
      )
    ''');
    // Create appointments table
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
  // Insert a checkup
  Future<int> insertCheckup(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('checkups', row);
  }
  // Insert an appointment
  Future<int> insertAppointment(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('appointments', row);
  }
  // Get all checkups
  Future<List<Map<String, dynamic>>> getCheckups() async {
    Database db = await database;
    return await db.query('checkups', orderBy: 'id DESC');
  }
  // Get all appointments
  Future<List<Map<String, dynamic>>> getAppointments() async {
    Database db = await database;
    return await db.query('appointments', orderBy: 'id DESC');
  }
  // Optional: delete all checkups
  Future<int> deleteAllCheckups() async {
    Database db = await database;
    return await db.delete('checkups');
  }
  // Optional: delete all appointments
  Future<int> deleteAllAppointments() async {
    Database db = await database;
    return await db.delete('appointments');
  }
}
