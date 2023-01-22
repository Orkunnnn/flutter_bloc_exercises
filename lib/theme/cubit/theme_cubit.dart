import 'package:flutter/material.dart';
import 'package:flutter_counter/weather/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

class ThemeCubit extends HydratedCubit<Color> {
  ThemeCubit() : super(defaultColor);

  static const defaultColor = Color(0xff2196f3);

  void updateTheme(Weather weather) {
    emit(weather.toColor);
  }

  @override
  Color? fromJson(Map<String, dynamic> json) {
    return Color(int.parse(json["color"] as String));
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return {"color": "${state.value}"};
  }
}

extension on Weather {
  Color get toColor {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return Colors.orangeAccent;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.unknown:
        return ThemeCubit.defaultColor;
    }
  }
}
