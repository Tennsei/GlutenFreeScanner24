import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/Pages/Home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.purple,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
        

          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

           NavigationDestination(
            selectedIcon: Icon(Icons.camera_alt_outlined),
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),

           NavigationDestination(
            selectedIcon: Icon(Icons.person_2_outlined),
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),

           NavigationDestination(
            selectedIcon: Icon(Icons.settings_outlined),
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
  

    );
  }
}