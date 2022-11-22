import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class gameCam extends StatefulWidget {
  const gameCam({Key? key}) : super(key: key);

  @override
  State<gameCam> createState() => _gameCamState();
}

class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x).take(ticks);
  }
}

class _gameCamState extends State<gameCam> {
  late StreamSubscription<int> subscription;
  int? _currentTick;
  bool _isPaused = false;

  @override
  initState() {
    super.initState();
    _start(30);
  }

  void _start(int duration) {
    subscription = Ticker().tick(ticks: duration).listen((value) {
      setState(() {
        _isPaused = false;
        _currentTick = value;
      });
    });
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    subscription.resume();
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
    subscription.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Text(
              _currentTick == null ? '' : _currentTick.toString(),
              style: TextStyle(fontSize: 100, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    subscription.cancel();
                    _start(30);
                  },
                  child: const Text('ReStart')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _isPaused ? _resume() : _pause();
                  },
                  child: Text(_isPaused ? 'Resume' : 'Stop'))
            ],
          )
        ],
      ),
    );
  }
}
