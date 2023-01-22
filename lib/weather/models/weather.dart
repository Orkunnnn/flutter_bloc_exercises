// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;
import 'package:weather_repository/weather_repository.dart';

part "weather.g.dart";

enum TemperatureUnit { fahrenheit, celcius }

extension TemperatureUnitExtension on TemperatureUnit {
  bool get isFahrenheit => this == TemperatureUnit.fahrenheit;
  bool get isCelcius => this == TemperatureUnit.celcius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  final double value;
  @override
  List<Object?> get props => [value];
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.weatherCondition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
  });
  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      weatherCondition: weather.weatherCondition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
    );
  }

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  static final empty = Weather(
    weatherCondition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    location: "-",
    temperature: const Temperature(value: 0),
  );

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final WeatherCondition weatherCondition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  @override
  List<Object?> get props =>
      [weatherCondition, lastUpdated, location, temperature];

  Weather copyWith({
    WeatherCondition? weatherCondition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
  }) {
    return Weather(
      weatherCondition: weatherCondition ?? this.weatherCondition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
    );
  }
}
