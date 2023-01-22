import 'package:test/test.dart';
import 'package:weather_repository/src/models/models.dart';

void main() {
  group(
    'Weather',
    () {
      test(
        'supports value comparasion',
        () {
          expect(
            const Weather(
              location: 'Chicago',
              temperature: 15.3,
              weatherCondition: WeatherCondition.clear,
            ),
            const Weather(
              location: 'Chicago',
              temperature: 15.3,
              weatherCondition: WeatherCondition.clear,
            ),
          );
        },
      );
      group(
        'toJson',
        () {
          test(
            'returns correct json object',
            () {
              final json = const Weather(
                location: 'Chicago',
                temperature: 15.3,
                weatherCondition: WeatherCondition.clear,
              ).toJson();
              expect(json, {
                'location': 'Chicago',
                'temperature': 15.3,
                'weather_condition': 'clear'
              });
            },
          );
        },
      );
      group(
        'fromJson',
        () {
          test(
            'returns correct Weather object',
            () {
              expect(
                Weather.fromJson(const {
                  'location': 'Chicago',
                  'temperature': 14,
                  'weather_condition': 'clear'
                }),
                isA<Weather>()
                    .having((p0) => p0.location, 'location', 'Chicago')
                    .having((p0) => p0.temperature, 'temperature', 14)
                    .having(
                      (p0) => p0.weatherCondition,
                      'weather_condition',
                      WeatherCondition.clear,
                    ),
              );
            },
          );
        },
      );
    },
  );
}
