import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/theme/cubit/theme_cubit.dart';
import 'package:flutter_counter/weather/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

import '../../helpers/hydrated_bloc.dart';

class MockWeather extends Mock implements Weather {
  MockWeather(this._weatherCondition);

  final WeatherCondition _weatherCondition;

  @override
  WeatherCondition get weatherCondition => _weatherCondition;
}

void main() {
  initHydratedStorage();

  group(
    "ThemeCubit",
    () {
      test(
        "initial state is correct",
        () {
          expect(ThemeCubit().state, ThemeCubit.defaultColor);
        },
      );
      group(
        "fromJson/toJson",
        () {
          test(
            "works properly",
            () {
              final themeCubit = ThemeCubit();
              expect(
                themeCubit.fromJson(themeCubit.toJson(themeCubit.state)),
                themeCubit.state,
              );
            },
          );
        },
      );
      group(
        "updateTheme",
        () {
          final clearWeather = MockWeather(WeatherCondition.clear);
          final snowyWeather = MockWeather(WeatherCondition.snowy);
          final rainyWeather = MockWeather(WeatherCondition.rainy);
          final cloudyWeather = MockWeather(WeatherCondition.cloudy);
          final unknownWeather = MockWeather(WeatherCondition.unknown);

          blocTest<ThemeCubit, Color>(
            "emits correct color for WeatherCondition.Clear",
            build: ThemeCubit.new,
            act: (bloc) => bloc.updateTheme(clearWeather),
            expect: () => [Colors.orangeAccent],
          );
          blocTest<ThemeCubit, Color>(
            "emits correct color for WeatherCondition.Snowy",
            build: ThemeCubit.new,
            act: (bloc) => bloc.updateTheme(snowyWeather),
            expect: () => [Colors.lightBlueAccent],
          );
          blocTest<ThemeCubit, Color>(
            "emits correct color for WeatherCondition.Cloudy",
            build: ThemeCubit.new,
            act: (bloc) => bloc.updateTheme(cloudyWeather),
            expect: () => [Colors.blueGrey],
          );
          blocTest<ThemeCubit, Color>(
            "emits correct color for WeatherCondition.Rainy",
            build: ThemeCubit.new,
            act: (bloc) => bloc.updateTheme(rainyWeather),
            expect: () => [Colors.indigoAccent],
          );
          blocTest<ThemeCubit, Color>(
            "emits correct color for WeatherCondition.Unknown",
            build: ThemeCubit.new,
            act: (bloc) => bloc.updateTheme(unknownWeather),
            expect: () => [ThemeCubit.defaultColor],
          );
        },
      );
    },
  );
}
