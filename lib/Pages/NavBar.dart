import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';
import 'package:test1/Pages/NavBarController.dart';




class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     // ignore: no_leading_underscores_for_local_identifiers
     NavBarController _controller = 
      Get.put(NavBarController());

      
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child:  Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20.0,
          ),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blueGrey,
            gap: 8,
            padding: const EdgeInsets.all(12),
            onTabChange: (value){
              _controller.index.value = value;
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(icon: Icons.camera_alt, text: 'Scan'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
          ),
        ),
      ),
       body: Obx(
          () =>  _controller.pages[_controller.index.value],
      )
    );
  }
}
