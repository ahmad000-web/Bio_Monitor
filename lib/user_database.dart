import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  /// Get database or initialize first time
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("app_database.db");
    return _database!;
  }

  /// Initialize DB with versioning
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // <-- IMPORTANT
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// ============================================================
  /// CREATE DATABASE TABLES (Executed only once on first install)
  /// ============================================================
  Future _createDB(Database db, int version) async {
    // USER TABLE
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        dob TEXT,
        password TEXT,
        gender TEXT,
        blood TEXT,
        photoPath TEXT
      )
    ''');

    // HEALTH DATA TABLE
    await db.execute('''
      CREATE TABLE health_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        bloodPressure INTEGER,
        heartRate INTEGER,
        temperature REAL,
        symptoms TEXT,
        isCritical INTEGER,
        createdAt TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // APPOINTMENTS TABLE
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        doctorName TEXT,
        appointmentDate TEXT,
        timeSlot TEXT,
        status TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  /// ============================================================
  /// SAFE UPGRADE (Runs automatically when version is increased)
  /// ============================================================
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add photoPath in Version 2
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE users ADD COLUMN photoPath TEXT");
    }

    // Add new tables in Version 3
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE health_data(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          bloodPressure INTEGER,
          heartRate INTEGER,
          temperature REAL,
          symptoms TEXT,
          isCritical INTEGER,
          createdAt TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE appointments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          doctorName TEXT,
          appointmentDate TEXT,
          timeSlot TEXT,
          status TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');
    }
  }

  /// ============================================================
  /// USER CRUD OPERATIONS
  /// ============================================================

  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await instance.database;
    try {
      return await db.insert("users", data);
    } catch (e) {
      print("Error inserting user: $e");
      return -1;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;

    final result = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final db = await instance.database;

    try {
      return await db.update(
        "users",
        data,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating user: $e");
      return -1;
    }
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    try {
      return await db.delete(
        "users",
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting user: $e");
      return -1;
    }
  }

  /// ============================================================
  /// HEALTH DATA CRUD OPERATIONS
  /// ============================================================

  Future<int> insertHealthData(Map<String, dynamic> data) async {
    final db = await instance.database;
    try {
      return await db.insert("health_data", data);
    } catch (e) {
      print("Error inserting health data: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getHealthDataByUser(int userId) async {
    final db = await instance.database;
    return await db.query(
      "health_data",
      where: "user_id = ?",
      whereArgs: [userId],
      orderBy: "createdAt DESC",
    );
  }

  Future<Map<String, dynamic>?> getLatestHealthData(int userId) async {
    final db = await instance.database;

    final result = await db.query(
      "health_data",
      where: "user_id = ?",
      whereArgs: [userId],
      orderBy: "createdAt DESC",
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteHealthRecord(int id) async {
    final db = await instance.database;

    try {
      return await db.delete(
        "health_data",
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting health record: $e");
      return -1;
    }
  }

  /// ============================================================
  /// APPOINTMENT CRUD OPERATIONS
  /// ============================================================

  Future<int> insertAppointment(Map<String, dynamic> data) async {
    final db = await instance.database;

    try {
      return await db.insert("appointments", data);
    } catch (e) {
      print("Error inserting appointment: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAppointmentsByUser(int userId) async {
    final db = await instance.database;

    return await db.query(
      "appointments",
      where: "user_id = ?",
      whereArgs: [userId],
      orderBy: "appointmentDate DESC",
    );
  }

  Future<int> updateAppointment(int id, Map<String, dynamic> data) async {
    final db = await instance.database;

    try {
      return await db.update(
        "appointments",
        data,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating appointment: $e");
      return -1;
    }
  }

  Future<int> deleteAppointment(int id) async {
    final db = await instance.database;

    try {
      return await db.delete(
        "appointments",
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting appointment: $e");
      return -1;
    }
  }

  /// Close DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
