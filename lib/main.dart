
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes_app/constants/routes.dart';
import 'package:mynotes_app/services/auth/auth_service.dart';
import 'package:mynotes_app/views/loginview.dart';
import 'package:mynotes_app/views/notes/new_note_view.dart';
import 'package:mynotes_app/views/notes/notesview.dart';
import 'package:mynotes_app/views/registerview.dart';
import 'package:mynotes_app/views/verifyemailview.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.firebase().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        RegisterRoute: (context) => const RegisterView(),
        NotesRoute: (context) => const NotesView(),
        NewNoteRoute: (context) => const NewNoteView(),
        VerifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          final user = AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
              devtools.log('You are a verified user');
              return const NotesView();
            } else {
              devtools.log('Verify email first');
              return const VerifyEmailView();
            }
          } else {
            return const LoginView();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}




