import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/weather/cubit/weather_cubit.dart';
import 'package:flutter_counter/weather/models/models.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route(WeatherCubit weatherCubit) => MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: weatherCubit,
          child: const SettingsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          BlocSelector<WeatherCubit, WeatherState, TemperatureUnit>(
            selector: (state) => state.temperatureUnit,
            builder: (context, state) => ListTile(
              title: const Text("Temperature Unit"),
              isThreeLine: true,
              subtitle:
                  const Text("Use metric measurements for temperature units"),
              trailing: Switch(
                value: state.isCelcius,
                onChanged: (value) =>
                    context.read<WeatherCubit>().toggleUnits(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
