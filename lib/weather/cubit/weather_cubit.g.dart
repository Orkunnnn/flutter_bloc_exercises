// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherState',
      json,
      ($checkedConvert) {
        final val = WeatherState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$WeatherStatusEnumMap, v) ??
                  WeatherStatus.initial),
          weather: $checkedConvert(
              'weather',
              (v) => v == null
                  ? null
                  : Weather.fromJson(v as Map<String, dynamic>)),
          temperatureUnit: $checkedConvert(
              'temperature_unit',
              (v) =>
                  $enumDecodeNullable(_$TemperatureUnitEnumMap, v) ??
                  TemperatureUnit.celcius),
        );
        return val;
      },
      fieldKeyMap: const {'temperatureUnit': 'temperature_unit'},
    );

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'weather': instance.weather.toJson(),
      'status': _$WeatherStatusEnumMap[instance.status]!,
      'temperature_unit': _$TemperatureUnitEnumMap[instance.temperatureUnit]!,
    };

const _$WeatherStatusEnumMap = {
  WeatherStatus.initial: 'initial',
  WeatherStatus.loading: 'loading',
  WeatherStatus.success: 'success',
  WeatherStatus.failure: 'failure',
};

const _$TemperatureUnitEnumMap = {
  TemperatureUnit.fahrenheit: 'fahrenheit',
  TemperatureUnit.celcius: 'celcius',
};
