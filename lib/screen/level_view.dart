import 'package:chopstick2/screen/camera.dart';
import 'package:chopstick2/screen/fire.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:chopstick2/services/locator.dart';
import 'package:chopstick2/services/inference_service.dart';

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
                          locator<InferenceService>().setModelConfig();
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Camera(title: "1단계");
                            },
                          ));
                        },
                        child: Text("Level 1"),
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
                          locator<InferenceService>().setModelConfig();
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Camera(title: "2단계");
                            },
                          ));
                        },
                        child: Text("Level 2"),
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
                          locator<InferenceService>().setModelConfig();
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Camera(title: "3단계");
                            },
                          ));
                        },
                        child: Text("Level 3"),
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      height: 70,
                      width: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple[4 * 100],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: fire()));
                        },
                        child: Text("폭죽"),
                      ),
                    )
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
