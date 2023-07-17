// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/colors.dart';
import 'package:collevo_teacher/services/auth/bloc/auth_bloc.dart';
import 'package:collevo_teacher/utilities/dialogs/error_dialog.dart';
import 'package:collevo_teacher/utilities/dialogs/reset_password_sent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.8;
    double maxWidth = 500.0;

    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              "Could not process request. Ensure that you're a registered user",
            );
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autofocus: true,
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: TextStyle(
                              color: CustomColors.blueGray,
                            ),
                            filled: true,
                            fillColor: CustomColors.manga,
                            contentPadding: EdgeInsets.all(16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CustomColors.voidColor,
                                  ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05 / 2,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final email = _controller.text;
                            context
                                .read<AuthBloc>()
                                .add(AuthEventForgotPassword(email: email));
                          },
                          child: const Text('Send reset email'),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05 / 2,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: const Text('Go to login page'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
