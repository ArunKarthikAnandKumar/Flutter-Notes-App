import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class verifyEmailview extends StatefulWidget {
  const verifyEmailview({super.key});

  @override
  State<verifyEmailview> createState() => _verifyEmailviewState();
}

class _verifyEmailviewState extends State<verifyEmailview> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),
      backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          const Text('Verify Email First'),
          TextButton(onPressed:()async{
            final user=FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, child:Text('Send Email Verification') )
        ],
      ),
    );
  }
}
