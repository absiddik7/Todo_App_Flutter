import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/model/todo_model.dart';


class DatabaseHelper {
  static const _databaseName = 'TodoData.db';
  static const _databaseVersion = 3;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${Todo.tableDailyTodo} ( 
  ${Todo.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, 
  ${Todo.columnTask} TEXT NT NULL)
''');

    await db.execute('''
create table ${Todo.tableWeeklyTodo} ( 
  ${Todo.columnId} integer primary key autoincrement, 
  ${Todo.columnTask} text not null)
''');

    await db.execute('''
create table ${Todo.tableMonthlyTodo} ( 
  ${Todo.columnId} integer primary key autoincrement, 
  ${Todo.columnTask} text not null)
''');
  }

// Insert Daily Task
  Future<int> insertDailyTask(Todo todo) async {
    Database db = await database;
    return await db.insert(Todo.tableDailyTodo,todo.toMap());
  }
  // Insert Weekly Task
  Future<int> insertWeeklyTask(Todo todo) async {
    Database db = await database;
    return await db.insert(Todo.tableWeeklyTodo,todo.toMap());
  }
  // Insert Monthly Task
  Future<int> insertMonthlyTask(Todo todo) async {
    Database db = await database;
    return await db.insert(Todo.tableMonthlyTodo,todo.toMap());
  }

  Future<int> update(Todo todo, String tableName) async {
    Database db = await database;
    return await db.update(tableName, todo.toMap(),
        where: '${Todo.columnId} = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int? id, String tableName) async {
    Database db = await database;
    return await db
        .delete(tableName, where: '${Todo.columnId} = ?', whereArgs: [id]);
  }

  Future<List<Todo>> getAllData(String tableName) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        task: maps[i]['task'],
      );
    });
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
