import 'package:flutter/material.dart';
import 'package:page_reveal/widgets/custom-text.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: CustomText(
              text: "Dashboard",
              fontSize: 24.0,
            ),
          )),
    );
  }
}

/*

Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
*/
