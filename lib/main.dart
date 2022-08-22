import 'package:flutter/material.dart';
import 'package:chopstick2/screen/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TabController controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BbongFlix',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(246, 222, 210, 210),
        accentColor: Color.fromARGB(246, 222, 210, 210),
      ),
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          body: TabBarView(
            physics:
                NeverScrollableScrollPhysics(), //사용자가 직접 손가락 모션을 통해서 스크롤 하는 기능을 막겠다.
            children: <Widget>[
              HomeScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
