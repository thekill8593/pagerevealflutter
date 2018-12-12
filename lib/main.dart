import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_reveal/models/task.dart';
import 'package:page_reveal/page_dragger.dart';
import 'package:page_reveal/page_reveal.dart';
import 'package:page_reveal/pager_indicator.dart';
import 'package:page_reveal/pages.dart';
import 'package:page_reveal/pages/create-task.dart';
import 'package:page_reveal/pages/edit-task.dart';
import 'package:page_reveal/pages/todo-list.dart';
import 'package:page_reveal/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.deepPurple[600],
            accentColor: Colors.deepPurple[600]),
        routes: {
          '/': (BuildContext context) => TodoList(model: _model),
          '/createtask': (BuildContext context) => CreateTask(model: _model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'editproduct') {
            final int taskId = int.parse(pathElements[2]);
            final Task task = _model.tasks.firstWhere((Task task) {
              return task.id == taskId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => EditTask(
                    task: task,
                    model: _model,
                  ),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          print("enter unknown");
          return MaterialPageRoute(
              builder: (BuildContext context) => CreateTask(
                    model: _model,
                  ));
        },
        //home: TodoList(),
      ),
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
                slideDirection: slideDirection,
                transitionGoal: TransitionGoal.open,
                slidePercent: slidePercent,
                slideUpdate: slideUpdateStream,
                vsync: this);
          } else {
            animatedPageDragger = AnimatedPageDragger(
                slideDirection: slideDirection,
                transitionGoal: TransitionGoal.close,
                slidePercent: slidePercent,
                slideUpdate: slideUpdateStream,
                vsync: this);
            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Page(
          viewModel: pages[activeIndex],
          percentVisible: 1.0,
        ),
        PageReveal(
          revealPercent: slidePercent,
          child: Page(
            viewModel: pages[nextPageIndex],
            percentVisible: slidePercent,
          ),
        ),
        PagerIndicator(
            viewModel: new PagerIndicatorViewModel(
                pages, activeIndex, slideDirection, slidePercent)),
        PageDragger(
          canDragLeftToRight: activeIndex > 0,
          canDragRightToLeft: activeIndex < pages.length - 1,
          slideUpdateStream: slideUpdateStream,
        )
      ],
    ));
  }
}
*/
