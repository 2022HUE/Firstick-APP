import 'package:chopstick2/screen/fire.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LevelView extends StatefulWidget {
  const LevelView({Key? key}) : super(key: key);
  @override
  _LevelViewState createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  @override
  void initState() {
    super.initState();
    Color:
    Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              child: Container(
                padding: EdgeInsets.only(top: 250),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple[1 * 100],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: LevelView()));
                        },
                        child: Text('Level 1'),
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      height: 70,
                      width: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple[2 * 100],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: LevelView()));
                        },
                        child: Text('Level 2'),
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      height: 70,
                      width: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple[3 * 100],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: fire()));
                        },
                        child: Text('Level 3'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    ));
  }
}
