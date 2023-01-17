import 'package:flutter/material.dart';
import 'package:flutter_counter/counter/counter.dart';
import 'package:flutter_counter/counter/view/counter_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "CounterPage",
    () {
      testWidgets(
        "renders CounterView",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: CounterPage(),
            ),
          );
          expect(find.byType(CounterView), findsOneWidget);
        },
      );
    },
  );
}
