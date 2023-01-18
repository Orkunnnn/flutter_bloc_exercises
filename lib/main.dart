import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/app.dart';
import 'package:flutter_counter/simle_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const InfiniteListApp());
}
