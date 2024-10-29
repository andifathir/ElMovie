import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/catatan/view/catatan_view.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../home/views/home_view.dart';

class NavbarController extends GetxController {
  final List<PersistentTabConfig> tabs = [
    PersistentTabConfig(
      screen: const HomeView(),
      item: ItemConfig(
        activeForegroundColor: Colors.white,
        inactiveBackgroundColor: Colors.white,
        icon: const Icon(Icons.home),
        title: "Home",
      ),
    ),
    PersistentTabConfig(
      screen: const HomeView(),
      item: ItemConfig(
        icon: const Icon(Icons.message),
        title: "Messages",
      ),
    ),
    PersistentTabConfig(
      screen: const HomeView(),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        title: "Settings",
      ),
    ),
     PersistentTabConfig(
      screen: CatatanView(),
      item: ItemConfig(
        icon: const Icon(Icons.book),
        title: "Catatan",
      ),
    ),
  ];
}
