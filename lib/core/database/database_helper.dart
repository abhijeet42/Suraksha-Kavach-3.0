import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/saved_sms_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('suraksha_kavach.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE sms_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sender TEXT NOT NULL,
  message TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  riskLevel TEXT NOT NULL,
  score REAL NOT NULL,
  flags TEXT NOT NULL
)
''');
  }

  Future<int> insertSms(SavedSmsRecord record) async {
    final db = await instance.database;
    return await db.insert('sms_history', record.toMap());
  }

  Future<List<SavedSmsRecord>> getAllHistory() async {
    final db = await instance.database;
    final orderBy = 'timestamp DESC';
    final result = await db.query('sms_history', orderBy: orderBy);
    return result.map((json) => SavedSmsRecord.fromMap(json)).toList();
  }

  Future<int> deleteSms(int id) async {
    final db = await instance.database;
    return await db.delete('sms_history', where: 'id = ?', whereArgs: [id]);
  }
  
  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('sms_history');
  }
}
