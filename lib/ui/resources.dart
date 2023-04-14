import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class Resources extends StatelessWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CountdownTimer(
          endTime: DateTime(2023, 4, 13, 15, 00).millisecondsSinceEpoch,
          endWidget: const Text('Class Link'),
          textStyle: const TextStyle(fontSize: 30, color: Colors.pink),
        ),
      ),
    );
  }
}
