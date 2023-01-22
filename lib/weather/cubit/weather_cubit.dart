// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import "package:flutter_counter/weather/models/models.dart";
import 'package:flutter_counter/weather/models/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

part "weather_cubit.g.dart";
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(
    this._weatherRepository,
  ) : super(WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather =
          Weather.fromRepository(await _weatherRepository.getWeather(city));
      final unit = state.temperatureUnit;
      final value = unit.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weather: weather.copyWith(temperature: Temperature(value: value)),
          temperatureUnit: unit,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(state.weather.location),
      );
      final unit = state.temperatureUnit;
      final value = unit.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnit: unit,
          weather: weather.copyWith(temperature: Temperature(value: value)),
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  void toggleUnits() {
    final unit = state.temperatureUnit.isFahrenheit
        ? TemperatureUnit.celcius
        : TemperatureUnit.fahrenheit;
    if (!state.status.isSuccess) {
      emit(state.copyWith(temperatureUnit: unit));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value = unit.isFahrenheit
          ? temperature.value.toFahrenheit()
          : temperature.value.toCelcius();
      emit(
        state.copyWith(
          temperatureUnit: unit,
          weather: weather.copyWith(temperature: Temperature(value: value)),
        ),
      );
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelcius() => (this - 32) * 5 / 9;
}
