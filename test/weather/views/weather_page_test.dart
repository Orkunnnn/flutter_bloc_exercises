import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/search/views/search_page.dart';
import 'package:flutter_counter/settings/views/settings_page.dart';
import 'package:flutter_counter/theme/cubit/theme_cubit.dart';
import 'package:flutter_counter/weather/views/weather_page.dart';
import 'package:flutter_counter/weather/weather.dart';
import 'package:flutter_counter/weather/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

import '../../helpers/hydrated_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockThemeCubit extends MockCubit<Color> implements ThemeCubit {}

class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {
}

void main() {
  initHydratedStorage();

  group(
    "WeatherPage",
    () {
      late WeatherRepository weatherRepository;

      setUp(
        () {
          weatherRepository = MockWeatherRepository();
        },
      );

      testWidgets(
        "renders WeatherView",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            RepositoryProvider.value(
              value: weatherRepository,
              child: const MaterialApp(
                home: WeatherPage(),
              ),
            ),
          );
          expect(find.byType(WeatherView), findsOneWidget);
        },
      );

      group(
        "WeatherView",
        () {
          final weather = Weather(
            lastUpdated: DateTime(2020),
            location: "London",
            temperature: const Temperature(value: 4.2),
            weatherCondition: WeatherCondition.cloudy,
          );

          late ThemeCubit themeCubit;
          late WeatherCubit weatherCubit;

          setUp(
            () {
              themeCubit = MockThemeCubit();
              weatherCubit = MockWeatherCubit();
            },
          );

          testWidgets(
            "renders Weather.empty for status WeatherStatus.initial",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState());

              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              expect(find.byType(WeatherEmpty), findsOneWidget);
            },
          );
          testWidgets(
            "renders WeatherLoading for status WeatherStatus.Loading",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState(status: WeatherStatus.loading));
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              expect(find.byType(WeatherLoading), findsOneWidget);
            },
          );
          testWidgets(
            "renders WeatherFailure for status WeatherStatus.failure",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState(status: WeatherStatus.failure));
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              expect(find.byType(WeatherError), findsOneWidget);
            },
          );
          testWidgets(
            "renders WeatherPopulated for status WeatherStatus.success",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState(status: WeatherStatus.success));
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              expect(find.byType(WeatherPopulated), findsOneWidget);
            },
          );
          testWidgets(
            "state is cached",
            (widgetTester) async {
              when(
                () => hydratedStorage.read("$WeatherCubit"),
              ).thenReturn(
                WeatherState(
                  status: WeatherStatus.success,
                  weather: weather,
                  temperatureUnit: TemperatureUnit.fahrenheit,
                ).toJson(),
              );
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: WeatherCubit(MockWeatherRepository()),
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              expect(find.byType(WeatherPopulated), findsOneWidget);
            },
          );
          testWidgets(
            "navigates to SettingsPage when settings icon is tapped",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState());
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              await widgetTester.tap(find.byType(IconButton));
              await widgetTester.pumpAndSettle();
              expect(find.byType(SettingsPage), findsOneWidget);
            },
          );
          testWidgets(
            "navigates to SearchPage when search icon is tapped",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState());
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              await widgetTester.tap(find.byType(FloatingActionButton));
              await widgetTester.pumpAndSettle();
              expect(find.byType(SearchPage), findsOneWidget);
            },
          );
          testWidgets(
            "calls updateTheme when weather changes",
            (widgetTester) async {
              whenListen(
                weatherCubit,
                Stream<WeatherState>.fromIterable([
                  WeatherState(),
                  WeatherState(status: WeatherStatus.success, weather: weather),
                ]),
              );
              when(() => weatherCubit.state).thenReturn(
                WeatherState(
                  status: WeatherStatus.success,
                  weather: weather,
                ),
              );
              await widgetTester.pumpWidget(
                MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: themeCubit),
                    BlocProvider.value(value: weatherCubit),
                  ],
                  child: const MaterialApp(home: WeatherView()),
                ),
              );
              verify(() => themeCubit.updateTheme(weather)).called(1);
            },
          );
          testWidgets(
            "triggers refreshWater on pull to refresh",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(
                WeatherState(
                  status: WeatherStatus.success,
                  weather: weather,
                ),
              );
              when(
                () => weatherCubit.refreshWeather(),
              ).thenAnswer((invocation) async => {});
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              await widgetTester.fling(
                find.text("London"),
                const Offset(0, 500),
                1000,
              );
              await widgetTester.pumpAndSettle();
              verify(
                () => weatherCubit.refreshWeather(),
              ).called(1);
            },
          );
          testWidgets(
            "triggers fetch on search pop",
            (widgetTester) async {
              when(
                () => weatherCubit.state,
              ).thenReturn(WeatherState());
              when(
                () => weatherCubit.fetchWeather(any()),
              ).thenAnswer((invocation) async => {});
              await widgetTester.pumpWidget(
                BlocProvider.value(
                  value: weatherCubit,
                  child: const MaterialApp(
                    home: WeatherView(),
                  ),
                ),
              );
              await widgetTester.tap(find.byType(FloatingActionButton));
              await widgetTester.pumpAndSettle();
              await widgetTester.enterText(find.byType(TextField), "Bolu");
              await widgetTester
                  .tap(find.byKey(const Key("searchPage_search_iconButton")));
              await widgetTester.pumpAndSettle();
              verify(
                () => weatherCubit.fetchWeather("Bolu"),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
