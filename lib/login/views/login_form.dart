import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/login/bloc/login_bloc.dart';
import 'package:formz/formz.dart';

part "login_form.part.dart";

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication Failure")),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          children: [
            _UsernameInput(),
            const SizedBox(
              height: 12,
            ),
            _PasswordInput(),
            const SizedBox(
              height: 12,
            ),
            _LoginButton()
          ],
        ),
      ),
    );
  }
}
