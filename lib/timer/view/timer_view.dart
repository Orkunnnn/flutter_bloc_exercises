import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_counter/timer/widgets/actions.dart';
import 'package:flutter_counter/timer/widgets/background.dart';
import 'package:flutter_counter/timer/widgets/timer_text.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Timer"),
      ),
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: TimerText(),
                ),
              ),
              Actions()
            ],
          )
        ],
      ),
    );
  }
}
