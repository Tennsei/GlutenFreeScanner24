import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/Pages/AuthGate.dart';
import 'firebase_options.dart';
import 'Pages/AuthGate.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Gluten Free Scanner',
      theme: ThemeData(),
      home: const AuthGate(),
    );
  }

}