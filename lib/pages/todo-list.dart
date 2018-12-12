import 'package:flutter/material.dart';
import 'package:page_reveal/models/task.dart';
import 'package:page_reveal/scoped_models/main.dart';
import 'package:page_reveal/widgets/custom-text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatefulWidget {
  final MainModel model;

  TodoList({@required this.model});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  initState() {
    widget.model.fetchTasks();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: CustomText(
              text: "Menu",
              fontSize: 26.0,
            ),
          ),
          ListTile(
            leading: Icon(Icons.access_alarm),
            title: CustomText(
              text: "Create new task",
              color: Colors.black,
            ),
            onTap: () {
              //Navigator.pushNamed(context, "/createtask");
              Navigator.popAndPushNamed(context, "/createtask");
              //Navigator.pushReplacementNamed(context, "/createtask");
            },
          )
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, MainModel model) {
    //final TimeOfDay time = TimeOfDay.;
    final DateTime date = DateTime.parse(task.date);

    return Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: BorderDirectional(
                bottom: BorderSide(width: 1.0, color: Colors.grey[400]))),
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Container(
          padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    text: task.task,
                    color: Colors.black,
                    textDecoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  task.completed
                      ? Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 28.0,
                          ),
                        )
                      : Container()
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.access_time,
                                size: 20.0, color: Colors.grey[600]),
                            CustomText(
                              text: date.hour.toString() +
                                  ":" +
                                  date.minute.toString(),
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today,
                                  size: 20.0, color: Colors.grey[600]),
                              CustomText(
                                text: date.day.toString() +
                                    "/" +
                                    date.month.toString() +
                                    "/" +
                                    date.year.toString(),
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: !task.completed ? 'Completed' : 'Not completed',
          color: !task.completed ? Colors.green : Colors.orange,
          icon: !task.completed ? Icons.check : Icons.clear,
          foregroundColor: Colors.white,
          onTap: () {
            model.makeTaskFavorite(task);
          },
        ),
        IconSlideAction(
          caption: 'Notifications',
          color: Colors.indigo,
          icon: task.notifications
              ? Icons.notifications
              : Icons.notifications_off,
          onTap: () {
            model.toggleNotifications(task);
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.deepPurple,
          icon: Icons.edit,
          onTap: () {
            print("edit pressed");
            Navigator.pushNamed(context, "/editproduct/${task.id}");
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            model.deleteTask(task);
          },
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    Widget taskElements;
    if (tasks.length > 0) {
      taskElements = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget widget, MainModel model) {
              return Container(child: _buildTaskCard(tasks[index], model));
            },
          );
        },
        itemCount: tasks.length,
      );
    } else {
      taskElements = Container(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(
                text: "You have no tasks",
                fontSize: 28.0,
                color: Colors.deepPurple,
              ),
              Icon(
                Icons.tag_faces,
                size: 28.0,
                color: Colors.deepPurple,
              )
            ],
          ),
        ),
      );
    }
    return taskElements;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: CustomText(
              text: "Tasks",
              fontSize: 24.0,
            ),
          ),
          body: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget widget, MainModel model) {
              return _buildTaskList(model.tasks);
            },
          )),
    );
  }
}
