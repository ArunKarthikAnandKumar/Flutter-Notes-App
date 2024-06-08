import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:mynotes_app/constants/routes.dart';
import 'package:mynotes_app/utilites/showErrorDialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register '),
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                    final user=FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    Navigator.of(context).pushNamed(VerifyEmailRoute);
                  } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorDialog(
                    context,
                    'Weak Password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialog(
                    context,
                    'Email already in use',
                  );

                } else if (e.code == 'invalid-email') {
                  showErrorDialog(
                    context,
                    'Invalid Email entered',
                  );

                } else {
                  showErrorDialog(
                    context,
                    'Error:${e.code}',
                  );

                }
              } catch (e) {
                showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login Here'))
        ],
      ),
    );
  }
}
