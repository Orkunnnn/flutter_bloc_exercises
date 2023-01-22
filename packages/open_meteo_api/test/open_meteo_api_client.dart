import 'dart:io';

import "package:http/http.dart" as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/src/models/models.dart';
import 'package:open_meteo_api/src/open_meteo_api_client.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockUri extends Mock implements Uri {}

void main() {
  group(
    "OpenMeteoApiClient",
    () {
      late MockHttpClient httpClient;
      late OpenMeteoApiClient openMeteoApiClient;

      setUpAll(() => registerFallbackValue(MockUri()));

      setUp(
        () {
          httpClient = MockHttpClient();
          openMeteoApiClient = OpenMeteoApiClient(httpClient: httpClient);
        },
      );

      group(
        "constructor",
        () {
          test(
            "does not require an httpClient",
            () {
              expect(OpenMeteoApiClient(), isNotNull);
            },
          );
        },
      );

      group(
        "locationSearch",
        () {
          const query = "mock-query";
          test(
            "makes correct http request",
            () async {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn("{}");
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);

              try {
                await openMeteoApiClient.locationSearch(query);
              } catch (_) {}
              verify(
                () => httpClient.get(
                  Uri.https(
                    "geocoding-api.open-meteo.com",
                    "/v1/search",
                    {"name": query, "count": 1},
                  ),
                ),
              ).called(1);
            },
          );
          test(
            "throws LocationRequestFailure on non 200 response",
            () {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.badRequest);
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
              expect(
                () async => openMeteoApiClient.locationSearch(query),
                throwsA(isA<LocationRequestFailure>()),
              );
            },
          );
          test(
            "throws LocationNotFound on empty response",
            () {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn('{"results": []}');
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
              expectLater(
                openMeteoApiClient.locationSearch(query),
                throwsA(isA<LocationNotFound>()),
              );
            },
          );
          test(
            "throws LocationNotFound on error response",
            () {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn("{}");
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
              expectLater(
                openMeteoApiClient.locationSearch(query),
                throwsA(isA<LocationNotFound>()),
              );
            },
          );
          test(
            "return Location on valid response",
            () async {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn('''
                {
                  "results": [
                    {
                      "id": 4887398,
                      "name": "Chicago",
                      "latitude": 41.85003,
                      "longitude": -87.65005
                    }
                  ]
                }
          ''');
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
              final actual = await openMeteoApiClient.locationSearch(query);
              expect(
                actual,
                isA<Location>()
                    .having((p0) => p0.id, "id", 4887398)
                    .having((p0) => p0.name, "name", "Chicago")
                    .having((p0) => p0.latitude, "latitude", 41.85003)
                    .having((p0) => p0.longitude, "longitude", -87.65003),
              );
            },
          );
        },
      );
      group(
        "getWeather",
        () {
          const latitude = 41.85003;
          const longitude = -87.65005;

          test(
            "makes correct http request",
            () async {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn("{}");
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);

              try {
                await openMeteoApiClient.getWeather(
                  latitude: latitude,
                  longitude: longitude,
                );
              } catch (_) {}
              verify(
                () => httpClient.get(
                  Uri.https("api.open-meteo.com", "/v1/forecast", {
                    "latitude": "$latitude",
                    "longitude": "$longitude",
                    "current_weather": true
                  }),
                ),
              ).called(1);
            },
          );
          test(
            "throws WeatherRequestFailure on non-200 response",
            () {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.badRequest);
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
            },
          );
          test(
            "throws WeatherNotFound on empty response",
            () {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn("{}");
              expect(
                () async => openMeteoApiClient.getWeather(
                  latitude: latitude,
                  longitude: longitude,
                ),
                throwsA(isA<WeatherNotFound>()),
              );
            },
          );
          test(
            "returns Weather on valid response",
            () async {
              final response = MockResponse();
              when(
                () => response.statusCode,
              ).thenReturn(HttpStatus.ok);
              when(
                () => response.body,
              ).thenReturn('''
              {
                "latitude": 43,
                "longitude": -87.875,
                "generationtime_ms": 0.25,
                "utc_offset_seconds": 0,
                "timezone": "GMT",
                "timezone_abbrevation": "GMT",
                "elevation": 189,
                "current_weather": {
                "temperature": 15.3,
                "windspeed": 25.8,
                "winddirection": 310,
                "weathercode": 63,
                "time": "2022-09-12T01:00"
                }
              }
        ''');
              when(
                () => httpClient.get(any()),
              ).thenAnswer((invocation) async => response);
              final actual = await openMeteoApiClient.getWeather(
                latitude: latitude,
                longitude: longitude,
              );
              expect(
                actual,
                isA<Weather>()
                    .having((p0) => p0.temperature, "temperature", 15.3)
                    .having((p0) => p0.weathercode, "weather_code", 63),
              );
            },
          );
        },
      );
    },
  );
}
