import 'package:open_meteo_api/open_meteo_api.dart' hide Weather;
import 'package:weather_repository/src/models/models.dart';

class WeatherRepository {
  WeatherRepository({OpenMeteoApiClient? weatherApi})
      : _weatherApi = weatherApi ?? OpenMeteoApiClient();
  final OpenMeteoApiClient _weatherApi;

  Future<Weather> getWeather(String city) async {
    final location = await _weatherApi.locationSearch(city);
    final weather = await _weatherApi.getWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return Weather(
      location: location.name,
      temperature: weather.temperature,
      weatherCondition: weather.weathercode.toInt().toCondition,
    );
  }
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}