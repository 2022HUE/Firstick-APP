import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/chopsticks.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white.withOpacity(0.1),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  //사진 콘테이너
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Image.asset('images/chopsticks.png'),
                                  height: 335,
                                ),
                                Container(
                                  //작품 간략한 정보
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "Welcome to Chopstick !",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  //작품 간략한 정보
                                  padding: EdgeInsets.only(top: 25),
                                  child: Text(
                                    "둘이 먹다 하나가 죽어도 젓가락질은 잘 하더라",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  //밑에 버튼 세개
                                  padding: EdgeInsets.fromLTRB(10, 80, 10, 100),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {},
                                          padding: EdgeInsets.only(top: 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 55,
                                            child: Text(
                                              '튜토리얼',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {},
                                          padding: EdgeInsets.only(top: 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 55,
                                            child: Text('교정',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {},
                                          padding: EdgeInsets.only(top: 0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 55,
                                            child: Text('미니게임',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
