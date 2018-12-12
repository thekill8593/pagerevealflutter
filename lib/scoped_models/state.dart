import 'package:page_reveal/database/db.dart';
import 'package:page_reveal/models/task.dart';
import 'package:scoped_model/scoped_model.dart';

class MainState extends Model {
  List<Task> _tasks = [];
  SqliteDatabase database = SqliteDatabase();
}

class TaskModel extends MainState {
  List<Task> get tasks {
    return List.from(_tasks);
  }

  Future<Null> fetchTasks() async {
    await database.initDatabase();
    List<Map> todos = await database.getData();
    final List<Task> listTask = [];
    for (var i = 0; i < todos.length; i++) {
      final notifications = todos[i]['notifications'] == 1 ? true : false;
      final completed = todos[i]['completed'] == 1 ? true : false;
      listTask.add(Task(
          id: todos[i]['id'],
          task: todos[i]['task'],
          date: todos[i]['date'],
          time: todos[i]['time'],
          notifications: notifications,
          completed: completed));
    }

    _tasks = listTask;
    notifyListeners();
  }

  Future<int> insertTask(Task task) async {
    await database.initDatabase();
    int res = await database.insert(task);
    List<Map> todos = await database.getData();
    final List<Task> listTask = [];
    for (var i = 0; i < todos.length; i++) {
      final notifications = todos[i]['notifications'] == 1 ? true : false;
      final completed = todos[i]['completed'] == 1 ? true : false;
      listTask.add(Task(
          id: todos[i]['id'],
          task: todos[i]['task'],
          date: todos[i]['date'],
          time: todos[i]['time'],
          notifications: notifications,
          completed: completed));
    }

    _tasks = listTask;
    notifyListeners();
    return res;
  }

  makeTaskFavorite(Task task) async {
    await database.initDatabase();
    final int completed = task.completed ? 0 : 1;
    await database.makeFavorite(task.id, completed);

    final Task updatedTask = Task(
        id: task.id,
        task: task.task,
        date: task.date,
        time: task.time,
        completed: !task.completed,
        notifications: task.notifications);

    _updateTaskUI(updatedTask);
  }

  Future<Null> toggleNotifications(Task task) async {
    await database.initDatabase();
    final int notifications = task.notifications ? 0 : 1;
    await database.activateNotifications(task.id, notifications);

    final Task updatedTask = Task(
        id: task.id,
        task: task.task,
        date: task.date,
        time: task.time,
        completed: task.completed,
        notifications: !task.notifications);

    _updateTaskUI(updatedTask);
  }

  _updateTaskUI(Task task) {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].id == task.id) {
        _tasks[i] = task;
        notifyListeners();
        return;
      }
    }
  }

  _deleteTaskFromUI(Task task) {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].id == task.id) {
        _tasks.removeAt(i);
        notifyListeners();
        return;
      }
    }
  }

  updateTask(Task task) async {
    await database.initDatabase();
    await database.updateTask(task);
    _updateTaskUI(task);
  }

  Future<Null> deleteTask(Task task) async {
    await database.initDatabase();
    await database.deleteTask(task.id);
    _deleteTaskFromUI(task);
  }

  //_fecthAllTasks
}
