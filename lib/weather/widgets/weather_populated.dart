// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_counter/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    super.key,
    required this.weather,
    required this.temperatureUnit,
    required this.onRefresh,
  });

  final Weather weather;
  final TemperatureUnit temperatureUnit;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        const _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  _WeatherIcon(weatherCondition: weather.weatherCondition),
                  Text(
                    weather.location == "Bolu"
                        ? "${weather.location}😁"
                        : weather.location,
                    style: theme.textTheme.headline2
                        ?.copyWith(fontWeight: FontWeight.w200),
                  ),
                  Text(
                    weather.formattedTemperatureUnit(temperatureUnit),
                    style: theme.textTheme.headline3
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '''Last updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({
    required this.weatherCondition,
  });

  static const _iconSize = 75.0;

  final WeatherCondition weatherCondition;

  @override
  Widget build(BuildContext context) {
    return Text(
      weatherCondition.toEmoji,
      style: const TextStyle(fontSize: _iconSize),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return "☀️";
      case WeatherCondition.rainy:
        return "🌧️";
      case WeatherCondition.cloudy:
        return "☁️";
      case WeatherCondition.snowy:
        return "🌨️";
      case WeatherCondition.unknown:
        return "❓";
    }
  }
}

class _WeatherBackground extends StatelessWidget {
  const _WeatherBackground();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.25, 0.75, 0.90, 1.0],
            colors: [
              color,
              color.brighten(),
              color.brighten(33),
              color.brighten(50)
            ],
          ),
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(
      1 <= percent && percent <= 100,
      "percantage must be between 1 and 100",
    );
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  String formattedTemperatureUnit(TemperatureUnit temperatureUnit) {
    return '''${temperature.value.toStringAsPrecision(2)}°${temperatureUnit.isCelcius ? "C" : "F"}''';
  }
}