import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  /// Return existing database or initialize
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("users.db");
    return _database!;
  }

  /// Initialize DB with versioning
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Version 2 includes photoPath
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create initial users table
  Future _createDB(Database db, int version) async {
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
  }

  /// Upgrade database without losing existing users
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add photoPath column for profile pictures
      await db.execute("ALTER TABLE users ADD COLUMN photoPath TEXT");
    }
  }

  /// Insert a new user
  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await instance.database;
    try {
      return await db.insert("users", data);
    } catch (e) {
      print("Error inserting user: $e");
      return -1;
    }
  }

  /// Login validation
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Update user including profile picture
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

  /// Delete user by ID
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

  /// Close database
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
