/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
///import 'package:flutter/rendering.dart';
///import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
///import 'package:firebase_ui_auth/firebase_ui_auth.dart';
///import 'auth_gate.dart';
///import 'package:openfoodfacts/openfoodfacts.dart';
///import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:test1/firebase_options.dart';
import 'package:test1/home.dart';

void main() async{
  runApp(MaterialApp(
    title: "Home",
    home: HomeScreen(),
  ));
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
}


  class MyApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page")
      ),
    );
  }

  }
*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';

// TODO(codelab user): Get API key
const clientId = 'YOUR_CLIENT_ID';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

  