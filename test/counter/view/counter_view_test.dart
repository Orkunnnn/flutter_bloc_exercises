import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

const _incrementButtonKey = Key("counterview_increment_floatingActionButton");
const _decrementButtonKey = Key("counterview_decrement_floatingActionButton");

void main() {
  late CounterCubit counterCubit;

  setUp(
    () {
      counterCubit = MockCounterCubit();
    },
  );

  group(
    "CounterView",
    () {
      testWidgets(
        "renders current CounterCubit state",
        (widgetTester) async {
          when(
            () => counterCubit.state,
          ).thenReturn(42);
          await widgetTester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: counterCubit,
                child: const CounterView(),
              ),
            ),
          );
          expect(find.text("42"), findsOneWidget);
        },
      );

      testWidgets(
        "tapping increment button invokes increment",
        (widgetTester) async {
          when(
            () => counterCubit.state,
          ).thenReturn(0);
          when(
            () => counterCubit.increment(),
          ).thenReturn(null);

          await widgetTester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: counterCubit,
                child: const CounterView(),
              ),
            ),
          );

          await widgetTester.tap(find.byKey(_incrementButtonKey));
          verify(
            () => counterCubit.increment(),
          ).called(1);
        },
      );

      testWidgets(
        "tapping decrement button invokes decrement",
        (widgetTester) async {
          when(
            () => counterCubit.state,
          ).thenReturn(0);
          when(
            () => counterCubit.decrement(),
          ).thenReturn(null);
          await widgetTester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: counterCubit,
                child: const CounterView(),
              ),
            ),
          );
          await widgetTester.tap(find.byKey(_decrementButtonKey));
          verify(
            () => counterCubit.decrement(),
          ).called(1);
        },
      );
    },
  );
}
