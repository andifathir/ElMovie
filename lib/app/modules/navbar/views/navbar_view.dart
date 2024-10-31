import 'package:ElMovie/app/modules/catatan/view/catatan_view.dart';
import 'package:ElMovie/app/modules/home/controllers/home_controller.dart';
import 'package:ElMovie/app/modules/home/views/home_view.dart';
import 'package:ElMovie/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "Persistent Bottom Navigation Bar Demo",
      home: MinimalExample(),
    );
  }
}

class MinimalExample extends StatelessWidget {
  const MinimalExample({super.key});

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HomeView(),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveBackgroundColor: Colors.white,
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const CatatanView(),
          item: ItemConfig(
            icon: const Icon(Icons.library_books),
            title: "Catatan",
          ),
        ),
        PersistentTabConfig(
          screen: ProfileView(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "Profile",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        backgroundColor: Colors.red,
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => Style9BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(color: Colors.black),
        ),
        navBarOverlap: NavBarOverlap.full(),
      );
}
