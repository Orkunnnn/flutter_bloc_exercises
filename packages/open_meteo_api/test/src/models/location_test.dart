import 'package:open_meteo_api/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Location",
    () {
      group(
        "fromJson",
        () {
          test(
            "returns correct Location object",
            () => expect(
              Location.fromJson({
                "id": 4888546,
                "name": "Chicago",
                "latitude": 41.85003,
                "longitude": -87.65005
              }),
              isA<Location>()
                  .having((p0) => p0.id, "id", 4888546)
                  .having((p0) => p0.name, "name", "Chicago")
                  .having((p0) => p0.latitude, "latitude", 41.85003)
                  .having((p0) => p0.longitude, "longitude", -87.65005),
            ),
          );
        },
      );
    },
  );
}
