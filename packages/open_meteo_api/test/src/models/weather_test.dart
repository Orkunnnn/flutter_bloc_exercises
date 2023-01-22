import 'package:open_meteo_api/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Weather",
    () {
      group(
        "fromJson",
        () {
          test(
            "returns correct Weather object",
            () {
              expect(
                Weather.fromJson({"temperature": 15.3, "weather_code": 63}),
                isA<Weather>()
                    .having((p0) => p0.temperature, "temperature", 15.3)
                    .having((p0) => p0.weathercode, "weatherCode", 63),
              );
            },
          );
        },
      );
    },
  );
}
