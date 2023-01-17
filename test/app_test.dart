import 'package:flutter_counter/app.dart';
import 'package:flutter_counter/counter/view/counter_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "CounterApp",
    () {
      testWidgets(
        "is a MaterialApp",
        (widgetTester) async {
          expect(const CounterApp(), isA<CounterApp>());
        },
      );

      testWidgets(
        "home is CounterPage",
        (widgetTester) async {
          expect(const CounterApp().home, isA<CounterPage>());
        },
      );

      testWidgets(
        "renders CounterPage",
        (widgetTester) async {
          await widgetTester.pumpWidget(const CounterApp());
          expect(find.byType(CounterPage), findsOneWidget);
        },
      );
    },
  );
}
