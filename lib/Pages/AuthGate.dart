import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/NavBar.dart';
import 'NavBar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: '158550708125-omf764b9t7lbkmcj5sk0gs3ckuu74tva.apps.googleusercontent.com')
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return const Padding(
                padding:  EdgeInsets.all(20),
                // child: AspectRatio(
                //   aspectRatio: 1,
                // ), used for if I want an image
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                ? const Text('Welcome to GF Scanner, Please sign in!')
                : const Text('Welcome to GF Scanner, Please sign up!'),
              );
            },
            sideBuilder: (context, constraints) {
              return const Padding(
                padding: EdgeInsets.all(20),
                //child: AspectRatio(aspectRatio: 1,) used for if I want an image
              );
            },
          );
        }
        return const NavBar();
      },
    );
  }
}