import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../controller/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PersistentTabView(
          backgroundColor: Colors.red,
          tabs: controller.tabs, // Ambil tabs dari NavbarController
          navBarBuilder: (navBarConfig) => Style9BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(color: Colors.black),
          ),
          navBarOverlap: NavBarOverlap.full(),
        ),
      );
}
