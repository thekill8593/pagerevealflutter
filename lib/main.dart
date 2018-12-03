import 'package:flutter/material.dart';
import 'package:page_reveal/page_reveal.dart';
import 'package:page_reveal/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Page Reveal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Page(
          viewModel: pages[0],
          percentVisible: 1.0,
        ),
        PageReveal(
          revealPercent: 1.0,
          child: Page(
            viewModel: pages[1],
            percentVisible: 1.0,
          ),
        )
      ],
    ));
  }
}
