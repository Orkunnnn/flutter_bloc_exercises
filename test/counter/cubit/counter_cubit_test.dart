import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_counter/counter/cubit/counter_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "CounterCubit",
    () {
      test(
        "initial state is 0",
        () {
          expect(CounterCubit().state, 0);
        },
      );
      group(
        "increment",
        () {
          blocTest<CounterCubit, int>(
            "emits [1] when state is 0",
            build: CounterCubit.new,
            act: (bloc) => bloc.increment(),
            expect: () => [1],
          );

          blocTest<CounterCubit, int>(
            "emits 2 when state is 0 and invoked twice",
            build: CounterCubit.new,
            act: (bloc) => bloc
              ..increment()
              ..increment(),
            expect: () => [1, 2],
          );

          blocTest<CounterCubit, int>(
            "emits 41 when state is 42",
            build: CounterCubit.new,
            act: (bloc) => bloc.decrement(),
            seed: () => 42,
            expect: () => [41],
          );

          blocTest<CounterCubit, int>(
            "emits -1 when state is 0",
            build: CounterCubit.new,
            act: (bloc) => bloc.decrement(),
            expect: () => [-1],
          );

          blocTest<CounterCubit, int>(
            "emits -2 when state is 0 and invoked twice",
            build: CounterCubit.new,
            act: (bloc) => bloc
              ..decrement()
              ..decrement(),
            expect: () => [-1, -2],
          );

          blocTest(
            "emits 42 when state is 41",
            build: CounterCubit.new,
            act: (bloc) => bloc.increment(),
            seed: () => 41,
            expect: () => [42],
          );
        },
      );
    },
  );
}
