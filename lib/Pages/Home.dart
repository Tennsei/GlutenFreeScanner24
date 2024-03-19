import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      ///Profile Page
       actions: [
         IconButton(
           icon: const Icon(Icons.person),
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute<ProfileScreen>(
                 builder: (context) => ProfileScreen(
                   appBar: AppBar(
                     title: const Text('User Profile'),
                   ),
                   actions: [
                     SignedOutAction((context) {
                       Navigator.of(context).pop();
                     })
                   ],
                 ),
               ),
             );
           },
         )
       ],
       automaticallyImplyLeading: false,
     ),
     //center of the app @TODO add something more to this page
     body: Center(
       child: Column(
         children: [
           Text(
             'Welcome User',
             style: Theme.of(context).textTheme.displaySmall,
           ),
            
         ],
       ),
     ),
     
   );
  }
}


