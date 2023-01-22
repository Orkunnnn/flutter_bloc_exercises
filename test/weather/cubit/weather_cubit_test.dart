import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_counter/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

import '../../helpers/hydrated_bloc.dart';

const weatherLocation = "London";
const weatherCondition = weather_repository.WeatherCondition.rainy;
const weatherTemperature = 9.8;

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  initHydratedStorage();

  group(
    "WeatherCubit",
    () {
      late weather_repository.Weather weather;
      late weather_repository.WeatherRepository weatherRepository;
      late WeatherCubit weatherCubit;

      setUp(
        () {
          weather = MockWeather();
          weatherRepository = MockWeatherRepository();
          when(
            () => weather.weatherCondition,
          ).thenReturn(weatherCondition);
          when(
            () => weather.temperature,
          ).thenReturn(weatherTemperature);
          when(
            () => weather.location,
          ).thenReturn(weatherLocation);
          when(
            () => weatherRepository.getWeather(any()),
          ).thenAnswer((invocation) async => weather);
          weatherCubit = WeatherCubit(weatherRepository);
        },
      );

      test(
        "initial state is correct",
        () {
          expect(weatherCubit.state, WeatherState());
        },
      );

      group(
        "fromJson/toJson",
        () {
          test(
            "works properly",
            () {
              expect(
                weatherCubit.fromJson(weatherCubit.toJson(weatherCubit.state)),
                weatherCubit.state,
              );
            },
          );
        },
      );

      group(
        "fetchWeather",
        () {
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when city is null",
            build: () => weatherCubit,
            act: (bloc) => bloc.fetchWeather(null),
            expect: () => <WeatherState>[],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when city is empty string",
            build: () => weatherCubit,
            act: (bloc) => bloc.fetchWeather(""),
            expect: () => <WeatherState>[],
          );
          blocTest<WeatherCubit, WeatherState>(
            "calls getWeather with correct city",
            build: () => weatherCubit,
            act: (bloc) => bloc.fetchWeather(weatherLocation),
            verify: (bloc) =>
                verify(() => weatherRepository.getWeather(weatherLocation))
                    .called(1),
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits [Loading, Failure] when getWeather throws error",
            setUp: () => when(() => weatherRepository.getWeather(any()))
                .thenThrow(Exception("exception")),
            build: () => weatherCubit,
            act: (bloc) => bloc.fetchWeather(weatherLocation),
            expect: () => [
              WeatherState(status: WeatherStatus.loading),
              WeatherState(status: WeatherStatus.failure)
            ],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits [Loading, Success] when getWeather returns (celcius)",
            build: () => weatherCubit,
            act: (bloc) => bloc.fetchWeather(weatherLocation),
            expect: () => <dynamic>[
              WeatherState(status: WeatherStatus.loading),
              isA<WeatherState>()
                  .having((p0) => p0.status, "status", WeatherStatus.success)
                  .having(
                    (p0) => p0.weather,
                    "weather",
                    isA<Weather>()
                        .having(
                          (p0) => p0.lastUpdated,
                          "lastUpdated",
                          isNotNull,
                        )
                        .having(
                          (p0) => p0.weatherCondition,
                          "weather_condition",
                          weatherCondition,
                        )
                        .having(
                          (p0) => p0.temperature,
                          "temperature",
                          const Temperature(value: weatherTemperature),
                        )
                        .having(
                          (p0) => p0.location,
                          "location",
                          weatherLocation,
                        ),
                  )
            ],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits [Loading, Success] when getWeather returns (fahrenheit)",
            build: () => weatherCubit,
            seed: () =>
                WeatherState(temperatureUnit: TemperatureUnit.fahrenheit),
            act: (bloc) => bloc.fetchWeather(weatherLocation),
            expect: () => <dynamic>[
              WeatherState(
                status: WeatherStatus.loading,
                temperatureUnit: TemperatureUnit.fahrenheit,
              ),
              isA<WeatherState>()
                  .having((p0) => p0.status, "status", WeatherStatus.success)
                  .having(
                    (p0) => p0.temperatureUnit,
                    "temperatureUnit",
                    TemperatureUnit.fahrenheit,
                  )
                  .having(
                    (p0) => p0.weather,
                    "weather",
                    isA<Weather>()
                        .having(
                          (p0) => p0.lastUpdated,
                          "lastUpdated",
                          isNotNull,
                        )
                        .having(
                          (p0) => p0.weatherCondition,
                          "weather_condition",
                          weatherCondition,
                        )
                        .having(
                          (p0) => p0.temperature,
                          "temperature",
                          Temperature(value: weatherTemperature.toFahrenheit()),
                        )
                        .having(
                          (p0) => p0.location,
                          "location",
                          weatherLocation,
                        ),
                  )
            ],
          );
        },
      );
      group(
        "refreshWeather",
        () {
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when status is not success",
            build: () => weatherCubit,
            act: (bloc) => bloc.refreshWeather(),
            expect: () => <WeatherState>[],
            verify: (bloc) =>
                verifyNever(() => weatherRepository.getWeather(any())),
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when location is null",
            build: () => weatherCubit,
            seed: () => WeatherState(status: WeatherStatus.success),
            expect: () => <WeatherState>[],
            verify: (bloc) =>
                verifyNever(() => weatherRepository.getWeather(any())),
          );
          blocTest<WeatherCubit, WeatherState>(
            "invokes getWeather with correct location",
            build: () => weatherCubit,
            seed: () => WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                weatherCondition: weatherCondition,
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
              ),
            ),
            act: (bloc) => bloc.refreshWeather(),
            verify: (bloc) =>
                verify(() => weatherRepository.getWeather(weatherLocation))
                    .called(1),
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when exception is thrown",
            setUp: () => when(() => weatherRepository.getWeather(any()))
                .thenThrow(Exception("exception")),
            seed: () => WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
                weatherCondition: weatherCondition,
              ),
            ),
            build: () => weatherCubit,
            act: (bloc) => bloc.refreshWeather(),
            expect: () => <WeatherState>[],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits updated weather (celcius)",
            build: () => weatherCubit,
            seed: () => WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                weatherCondition: weatherCondition,
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
              ),
            ),
            act: (bloc) => bloc.refreshWeather(),
            expect: () => [
              isA<WeatherState>()
                  .having((p0) => p0.status, "status", WeatherStatus.success)
                  .having(
                    (p0) => p0.weather,
                    "weather",
                    isA<Weather>()
                        .having(
                          (p0) => p0.lastUpdated,
                          "lastUpdated",
                          isNotNull,
                        )
                        .having(
                          (p0) => p0.weatherCondition,
                          "weatherCondition",
                          weatherCondition,
                        )
                        .having(
                          (p0) => p0.location,
                          "location",
                          weatherLocation,
                        )
                        .having(
                          (p0) => p0.temperature,
                          "temperature",
                          const Temperature(value: weatherTemperature),
                        ),
                  )
            ],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits nothing when exception is thrown",
            setUp: () => when(() => weatherRepository.getWeather(any()))
                .thenThrow(Exception("exception")),
            seed: () => WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
                weatherCondition: weatherCondition,
              ),
            ),
            build: () => weatherCubit,
            act: (bloc) => bloc.refreshWeather(),
            expect: () => <WeatherState>[],
          );
          blocTest<WeatherCubit, WeatherState>(
            "emits updated weather (celcius)",
            build: () => weatherCubit,
            seed: () => WeatherState(
              status: WeatherStatus.success,
              temperatureUnit: TemperatureUnit.fahrenheit,
              weather: Weather(
                weatherCondition: weatherCondition,
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
              ),
            ),
            act: (bloc) => bloc.refreshWeather(),
            expect: () => [
              isA<WeatherState>()
                  .having((p0) => p0.status, "status", WeatherStatus.success)
                  .having(
                    (p0) => p0.weather,
                    "weather",
                    isA<Weather>()
                        .having(
                          (p0) => p0.lastUpdated,
                          "lastUpdated",
                          isNotNull,
                        )
                        .having(
                          (p0) => p0.weatherCondition,
                          "weatherCondition",
                          weatherCondition,
                        )
                        .having(
                          (p0) => p0.location,
                          "location",
                          weatherLocation,
                        )
                        .having(
                          (p0) => p0.temperature,
                          "temperature",
                          Temperature(value: weatherTemperature.toFahrenheit()),
                        ),
                  )
            ],
          );
        },
      );
      group(
        "toggleUnit",
        () {
          blocTest<WeatherCubit, WeatherState>(
            "emits updated unit when status is not success",
            build: () => weatherCubit,
            act: (bloc) => bloc.toggleUnits(),
            expect: () =>
                [WeatherState(temperatureUnit: TemperatureUnit.fahrenheit)],
          );
          blocTest<WeatherCubit, WeatherState>(
            '''emits updated unit and temperature when status is success (celcius)''',
            build: () => weatherCubit,
            seed: () => WeatherState(
              status: WeatherStatus.success,
              temperatureUnit: TemperatureUnit.fahrenheit,
              weather: Weather(
                location: weatherLocation,
                lastUpdated: DateTime(2020),
                temperature: const Temperature(value: weatherTemperature),
                weatherCondition: weather_repository.WeatherCondition.rainy,
              ),
            ),
            act: (bloc) => bloc.toggleUnits(),
            expect: () => [
              WeatherState(
                status: WeatherStatus.success,
                weather: Weather(
                  weatherCondition: weather_repository.WeatherCondition.rainy,
                  lastUpdated: DateTime(2020),
                  location: weatherLocation,
                  temperature:
                      Temperature(value: weatherTemperature.toCelsius()),
                ),
              )
            ],
          );
          blocTest<WeatherCubit, WeatherState>(
            '''emits updated unit and temperature when status is success (fahrenheit)''',
            build: () => weatherCubit,
            act: (bloc) => bloc.toggleUnits(),
            seed: () => WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                weatherCondition: weatherCondition,
                lastUpdated: DateTime(2020),
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
              ),
            ),
            expect: () => [
              WeatherState(
                status: WeatherStatus.success,
                temperatureUnit: TemperatureUnit.fahrenheit,
                weather: Weather(
                  lastUpdated: DateTime(2020),
                  location: weatherLocation,
                  temperature:
                      Temperature(value: weatherTemperature.toFahrenheit()),
                  weatherCondition: weatherCondition,
                ),
              )
            ],
          );
        },
      );
    },
  );
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
