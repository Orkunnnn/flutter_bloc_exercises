import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements open_meteo_api.Location {}

class MockWeather extends Mock implements open_meteo_api.Weather {}

void main() {
  group(
    "WeatherRepository",
    () {
      late open_meteo_api.OpenMeteoApiClient weatherApiClient;
      late WeatherRepository weatherRepository;

      setUp(
        () {
          weatherApiClient = MockOpenMeteoApiClient();
          weatherRepository = WeatherRepository(weatherApi: weatherApiClient);
        },
      );

      group(
        "constructor",
        () {
          test(
            "instantiates internal weather api client when not injected",
            () {
              expect(WeatherRepository(), isNotNull);
            },
          );
        },
      );

      group(
        "getWeather",
        () {
          const city = "Chicago";
          const latitude = 41.85003;
          const longitude = -87.65005;

          test(
            "calls locationSearch with correct city",
            () async {
              try {
                await weatherRepository.getWeather(city);
              } catch (_) {}
              verify(
                () => weatherApiClient.locationSearch(city),
              ).called(1);
            },
          );
          test(
            "throws exception when locationSearch fails",
            () {
              final exception = Exception("exception");
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenThrow(exception);
              expect(
                () => weatherRepository.getWeather(city),
                throwsA(exception),
              );
            },
          );
          test(
            "calls getWeather with correct latitude/longitude",
            () async {
              final location = MockLocation();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              try {
                await weatherRepository.getWeather(city);
              } catch (_) {}
              verify(
                () => weatherApiClient.getWeather(
                  latitude: latitude,
                  longitude: longitude,
                ),
              ).called(1);
            },
          );
          test(
            "throws exception when getWeather fails",
            () {
              final exception = Exception("exception");
              final location = MockLocation();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => weatherApiClient.locationSearch(city),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenThrow(exception);
              expect(
                () => weatherRepository.getWeather(city),
                throwsA(exception),
              );
            },
          );
          test(
            "returns correct weather on success (clear)",
            () async {
              final location = MockLocation();
              final weather = MockWeather();

              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => location.name,
              ).thenReturn(city);
              when(
                () => weather.temperature,
              ).thenReturn(15.3);
              when(
                () => weather.weathercode,
              ).thenReturn(0);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenAnswer((invocation) async => weather);
              final actual = await weatherRepository.getWeather(city);
              expect(
                actual,
                const Weather(
                  location: city,
                  temperature: 15.3,
                  weatherCondition: WeatherCondition.clear,
                ),
              );
            },
          );
          test(
            "returns correct weather on success (cloudy)",
            () async {
              final location = MockLocation();
              final weather = MockWeather();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => location.name,
              ).thenReturn(city);
              when(
                () => weather.temperature,
              ).thenReturn(15.3);
              when(
                () => weather.weathercode,
              ).thenReturn(48);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenAnswer((invocation) async => weather);
              final actual = await weatherRepository.getWeather(city);
              expect(
                actual,
                const Weather(
                  location: city,
                  temperature: 15.3,
                  weatherCondition: WeatherCondition.cloudy,
                ),
              );
            },
          );
          test(
            "returns correct weather on success (rainy)",
            () async {
              final location = MockLocation();
              final weather = MockWeather();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => location.name,
              ).thenReturn(city);
              when(
                () => weather.temperature,
              ).thenReturn(15.3);
              when(
                () => weather.weathercode,
              ).thenReturn(99);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenAnswer((invocation) async => weather);
              final actual = await weatherRepository.getWeather(city);
              expect(
                actual,
                const Weather(
                  location: city,
                  temperature: 15.3,
                  weatherCondition: WeatherCondition.rainy,
                ),
              );
            },
          );
          test(
            "returns correct weather on success (snowy)",
            () async {
              final location = MockLocation();
              final weather = MockWeather();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => location.name,
              ).thenReturn(city);
              when(
                () => weather.temperature,
              ).thenReturn(15.3);
              when(
                () => weather.weathercode,
              ).thenReturn(86);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenAnswer((invocation) async => weather);
              final actual = await weatherRepository.getWeather(city);
              expect(
                actual,
                const Weather(
                  location: city,
                  temperature: 15.3,
                  weatherCondition: WeatherCondition.snowy,
                ),
              );
            },
          );
          test(
            "returns correct weather on success (unknown)",
            () async {
              final location = MockLocation();
              final weather = MockWeather();
              when(
                () => location.latitude,
              ).thenReturn(latitude);
              when(
                () => location.longitude,
              ).thenReturn(longitude);
              when(
                () => location.name,
              ).thenReturn(city);
              when(
                () => weather.temperature,
              ).thenReturn(15.3);
              when(
                () => weather.weathercode,
              ).thenReturn(-1);
              when(
                () => weatherApiClient.locationSearch(any()),
              ).thenAnswer((invocation) async => location);
              when(
                () => weatherApiClient.getWeather(
                  latitude: any(named: "latitude"),
                  longitude: any(named: "longitude"),
                ),
              ).thenAnswer((invocation) async => weather);
              final actual = await weatherRepository.getWeather(city);
              expect(
                actual,
                const Weather(
                  location: city,
                  temperature: 15.3,
                  weatherCondition: WeatherCondition.unknown,
                ),
              );
            },
          );
        },
      );
    },
  );
}
