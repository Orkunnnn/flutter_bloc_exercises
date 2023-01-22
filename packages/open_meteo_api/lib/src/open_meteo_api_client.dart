import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:open_meteo_api/src/models/models.dart';

class LocationRequestFailure implements Exception {}

class LocationNotFound implements Exception {}

class WeatherRequestFailure implements Exception {}

class WeatherNotFound implements Exception {}

class OpenMeteoApiClient {
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = "api.open-meteo.com";
  static const _baseUrlGeocoding = "geocoding-api.open-meteo.com";

  final http.Client _httpClient;

  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
        _baseUrlGeocoding, "/v1/search", {"name": query, "count": "1"});

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != HttpStatus.ok) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey("results")) {
      throw LocationNotFound();
    }

    final results = locationJson["results"] as List;

    if (results.isEmpty) throw LocationNotFound();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, "/v1/forecast", {
      "latitude": "$latitude",
      "longitude": "$longitude",
      "current_weather": "true"
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != HttpStatus.ok) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map;

    if (!bodyJson.containsKey("current_weather")) {
      throw WeatherNotFound();
    }

    final weatherJson = bodyJson["current_weather"] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }
}
