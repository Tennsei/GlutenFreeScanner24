import 'package:get/get.dart';
import 'package:test1/Pages/AuthGate.dart';
import 'package:test1/Pages/BarcodeScan.dart';
import 'package:test1/Pages/Home.dart';
import 'package:test1/Pages/Search.dart';
import 'package:test1/Pages/Settings.dart';



class NavBarController extends GetxController {
  RxInt index = 0.obs;
  var pages = [
    HomeScreen(),
    ScanCode(),
    FoodSearch(),
    AuthGate(),
    SettingsScreen()
    
  ];
}