import 'package:page_reveal/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  String path = "";
  Database database;

  Future<Null> connect() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'todolist.db');
  }

  Future<Null> initDatabase() async {
    await connect();
    //await deleteDatabase(path);
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, date TEXT, time TEXT, notifications INTEGER, completed INTEGER)');
      print("database created");
    });
  }

  Future<Null> insert(Task task) async {
    await database.insert("todo", task.toMap());
  }

  Future<Null> makeFavorite(int taskId, int completed) async {
    await database.rawQuery(
        "UPDATE todo SET completed = ${completed} where id = ${taskId}");
  }

  Future<List<Map>> getData() async {
    List<Map> list =
        await database.rawQuery('SELECT * FROM todo ORDER BY id DESC');
    return list;
  }

  Future<Null> deleteTask(int taskId) async {
    await database.rawQuery("DELETE FROM todo where id = ${taskId}");
  }

  Future<Null> activateNotifications(int taskId, int notifications) async {
    await database.rawQuery(
        "UPDATE todo SET notifications = ${notifications} where id = ${taskId}");
  }

  Future<Null> updateTask(Task task) async {
    final int _notifications = task.notifications ? 1 : 0;
    final int _completed = task.completed ? 1 : 0;
    await database.rawQuery(
        "UPDATE todo SET task = '${task.task}', date = '${task.date}', time = '${task.time}', notifications = ${_notifications}, completed = ${_completed} where id = ${task.id}");
  }
}
