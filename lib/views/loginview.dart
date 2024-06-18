import 'package:flutter/material.dart';
import 'package:mynotes_app/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilites/dialog/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "    Enter Your email"),
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
            decoration:
                const InputDecoration(hintText: "    Enter Your Password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    NotesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    VerifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException catch (e) {
                showErrorDialog(
                  context,
                  'User Not Found',
                );
              } on WrongPasswordAuthException {
                showErrorDialog(
                  context,
                  'Wrong Password',
                );
              } on GenericAuthException {
                showErrorDialog(
                  context,
                  'Authentication Error',
                );
              } catch (e) {
                showErrorDialog(
                  context,
                  e.toString(),
                );
                devtools.log('Something Bad Happened');
                devtools.log('Error: $e');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RegisterRoute,
                  (route) => false,
                );
              },
              child: const Text('Not Registered yet? Register Here'))
        ],
      ),
    );
  }
}
