import 'package:flutter/material.dart';

class AddChopstick extends StatefulWidget {
  const AddChopstick({Key? key}) : super(key: key);
  @override
  _AddChopstickState createState() => _AddChopstickState();
}

class _AddChopstickState extends State<AddChopstick> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            child: Text(
              '젓가락을\n이동시키세요',
              textAlign: TextAlign.center,
            ),
          ),
          Draggable<String>(
            // Data is the value this Draggable stores.
            data: 'red',

            child: Container(
              height: 120.0,
              width: 50.0,
              child: Center(
                child: Image.asset('assets/images/left_chop.png'),
              ),
            ),
            feedback: Container(
              height: 120.0,
              width: 50.0,
              child: Center(
                child: Image.asset('assets/images/left_chop.png'),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
