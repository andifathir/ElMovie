import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart'; // Import PersistentTabView

import '../../../routes/app_pages.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart'; // Import HomeController
import '../../navbar/controller/navbar_controller.dart'; // Import NavbarController

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  final NavbarController navbarController =
      Get.put(NavbarController()); // Initialize NavbarController

  List<Widget> _buildScreens() {
    return [
      _buildMovieRecommendations(),
      const ProfileView(), // Example of another screen, replace with your desired view
      // Add more views here
    ];
  }

  List<PersistentTabConfig> _buildNavBarItems() {
    return [
      PersistentTabConfig(
        screen: _buildMovieRecommendations(),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          title: "Home",
        ),
      ),
      PersistentTabConfig(
        screen: const ProfileView(),
        item: ItemConfig(
          icon: const Icon(Icons.person),
          title: "Profile",
        ),
      ),
    ];
  }

  Widget _buildMovieRecommendations() {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          height: 25,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MouseRegion(
              cursor: SystemMouseCursors.click, // Change cursor on hover
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileView()),
                  );
                },
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundImage: profileProvider.profileImage != null
                          ? FileImage(profileProvider.profileImage!)
                          : null,
                      child: profileProvider.profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/BG_BELAKANG_HOME.png'), // Use the path to your image
            fit: BoxFit.cover, // Adjust to cover the entire container
          ),
        ),
        child: Obx(() {
          if (homeController.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (homeController.movies.isEmpty) {
            return Center(
                child: Text('No movies found',
                    style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              itemCount: homeController.movies.length,
              itemBuilder: (context, index) {
                final movie = homeController.movies[index];
                return Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      movie.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${movie.description}',
                            style: TextStyle(color: Colors.white)),
                        Text('Year: ${movie.year}',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 236, 137, 0))),
                        Text('Rating: ${movie.rating}',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 236, 137, 0))),
                      ],
                    ),
                    leading: SizedBox(
                      width: 100,
                      height: 150,
                      child: movie.thumbnail.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(1.0),
                              child: Image.network(
                                movie.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image, size: 100),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.MOVIE_DETAILS, arguments: movie);
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: Colors.black,
      tabs: _buildNavBarItems(),
      navBarBuilder: (navBarConfig) => Style9BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(color: Colors.black),
      ),
      navBarOverlap: NavBarOverlap.full(),
    );
  }
}
