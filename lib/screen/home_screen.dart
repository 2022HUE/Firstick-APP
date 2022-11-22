import 'dart:ui';
import 'dart:math';
import 'package:chopstick2/screen/fire.dart';
import 'package:chopstick2/screen/level_view.dart';
import 'package:chopstick2/screen/video.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:chopstick2/services/locator.dart';
import 'package:chopstick2/services/inference_service.dart';
import 'package:chopstick2/screen/camera.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> saying = [
    '둘이 먹다 하나가 죽어도\n 젓가락질은 잘하더라',
    '고기 잃고\n 젓가락질 고치기',
    '열 길 물 속은 알아도\n 올바른 젓가락질은 모른다',
    '젓가락질 삼 주에\n 풍월을 읊는다',
    '귀신이 젓가락질 할 노릇',
    '믿는 젓가락에\n 입술 씹힌다',
    '가는 콩이 고와야\n 오는 콩이 곱다',
    '내 젓가락이 석자다',
    '늦게 배운 젓가락질\n 날 새는 줄 모른다',
    '다 된 밥에\n 젓가락 뿌린다',
    '젓가락도 맞들면 낫다',
    '빈 젓가락이\n 더 요란하다',
    '세살 버릇\n 여든까지 간다',
    '젓가락도 맞들면 낫다',
    '빈 젓가락이 더 요란하다',
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
                        image: AssetImage('assets/images/design_main.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRect(
                      // child: BackdropFilter(
                      // filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                      child: Container(
                        alignment: Alignment.center,
                        // color: Colors.white.withOpacity(0.1),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                //사진 콘테이너
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                // child:
                                //     Image.asset('assets/images/chopsticks.png'),
                                height: 150,
                              ),
                              Container(
                                  //작품 간략한 정보
                                  // padding: EdgeInsets.only(top: 120),
                                  // child: Text(
                                  //   "Welcome to Chopstick !",
                                  //   style: TextStyle(
                                  //       fontFamily: '롯데마트B',
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 35,
                                  //       color: Colors.white),
                                  // ),
                                  ),
                              Container(
                                //작품 간략한 정보
                                padding: EdgeInsets.only(top: 250, left: 30),
                                height: 370,
                                width: 250,
                                alignment: Alignment.center,
                                child: DefaultTextStyle(
                                    style: TextStyle(
                                        fontFamily: '롯데마트B',
                                        fontSize: 22,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                    child: AnimatedTextKit(
                                        //Typerwiter 애니메이션 사용
                                        animatedTexts: [
                                          TyperAnimatedText(
                                              saying[
                                                  rnd], // 속담 랜덤으로 애니메이션 적용해서 출력
                                              speed: const Duration(
                                                  milliseconds:
                                                      300)) // 애니메이션 글자당 일시중지 시간
                                        ],
                                        repeatForever: true, // 애니메이션 영원히 반복
                                        pause: const Duration(
                                            milliseconds:
                                                5000))), //애니메이션 사이 일시중지 시간
                              ),
                              Container(
                                //밑에 버튼 세개
                                padding: EdgeInsets.fromLTRB(20, 120, 20, 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: VideoPlayerApp()));
                                        },
                                        padding: EdgeInsets.only(top: 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 55,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 53,
                                              child: Text(
                                                '튜토리얼',
                                                style: TextStyle(
                                                    fontFamily: '롯데마트B',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          locator<InferenceService>()
                                              .setModelConfig();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Camera();
                                            },
                                          ));
                                        },
                                        padding: EdgeInsets.only(top: 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 55,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 53,
                                              child: Text('교정',
                                                  style: TextStyle(
                                                      fontFamily: '롯데마트B',
                                                      fontSize: 16,
                                                      color: Colors.black))),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: LevelView()));
                                        },
                                        padding: EdgeInsets.only(top: 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 55,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 53,
                                              child: Text(
                                                '미니게임',
                                                style: TextStyle(
                                                    fontFamily: '롯데마트B',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )),
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
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
