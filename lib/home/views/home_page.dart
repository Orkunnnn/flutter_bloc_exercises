import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/authentication/bloc/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const HomePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                final userId = context
                    .select((AuthenticationBloc bloc) => bloc.state.user.id);
                return Text("User ID: $userId");
              },
            ),
            ElevatedButton(
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogOutRequested()),
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
