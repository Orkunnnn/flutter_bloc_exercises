// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusExtension on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

@JsonSerializable()
class WeatherState extends Equatable {
  WeatherState({
    this.status = WeatherStatus.initial,
    Weather? weather,
    this.temperatureUnit = TemperatureUnit.celcius,
  }) : weather = weather ?? Weather.empty;

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);

  final Weather weather;
  final WeatherStatus status;
  final TemperatureUnit temperatureUnit;

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  @override
  List<Object> get props => [weather, status, temperatureUnit];

  WeatherState copyWith({
    Weather? weather,
    WeatherStatus? status,
    TemperatureUnit? temperatureUnit,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      status: status ?? this.status,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }
}
