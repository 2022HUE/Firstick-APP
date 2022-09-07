import 'dart:ui';
import 'dart:math';
import 'package:chopstick2/screen/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> saying = [
    '둘이 먹다 하나가 죽어도 젓가락질은 잘하더라',
    '고기 잃고 젓가락질 고치기',
    '열 길 물 속은 알아도 올바른 젓가락질 방법은 모른다',
    '젓가락질 삼 주에 풍월을 읊는다',
    '귀신이 젓가락질 할 노릇',
    '믿는 젓가락에 입술 씹힌다',
    '가는 콩이 고와야 오는 콩이 곱다',
    '내 젓가락이 석자다',
    '늦게 배운 젓가락질 날 새는 줄 모른다',
    '다 된 밥에 젓가락 뿌린다',
    '젓가락도 맞들면 낫다',
    '빈 젓가락이 더 요란하다',
    '세살 버릇 여든까지 간다',
    '젓가락도 맞들면 낫다',
    '빈 젓가락이 더 요란하다',
    '세살 버릇 여든까지 간다'
  ];

  // String filePath = 'script.txt';
  // String fileText = '환영합니다';

  void readFile() async {
    // String text = await rootBundle.loadString(filePath);
    await Future.delayed(Duration(seconds: 9));
    setState(() {
      // fileText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    readFile();
    // final rows = fileText.split('\n');
    final rnd = Random().nextInt(saying.length - 1);

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
                        image: AssetImage('assets/images/chopsticks.png'),
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
                                  child: Image.asset(
                                      'assets/images/chopsticks.png'),
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
                                  height: 55,
                                  alignment: Alignment.center,
                                  child: DefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                      child: AnimatedTextKit(
                                          animatedTexts: [
                                            TyperAnimatedText(saying[rnd],
                                                speed: const Duration(
                                                    milliseconds: 300))
                                          ],
                                          repeatForever: true,
                                          pause: const Duration(
                                              milliseconds: 5000))),
                                ),
                                Container(
                                  //밑에 버튼 세개
                                  padding: EdgeInsets.fromLTRB(10, 30, 10, 100),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerScreen()),
                                            );
                                          },
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
