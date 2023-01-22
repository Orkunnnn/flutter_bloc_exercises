import 'package:json_annotation/json_annotation.dart';

part "weather.g.dart";

@JsonSerializable()
class Weather {
  Weather({required this.temperature, required this.weathercode});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  final double temperature;
  final double weathercode;
}
