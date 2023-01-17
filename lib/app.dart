import 'package:flutter/material.dart';
import 'package:flutter_counter/timer/view/timer_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Timer",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const TimerPage(),
    );
  }
}
