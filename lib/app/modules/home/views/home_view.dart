import 'package:flutter/material.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
import 'package:ElMovie/app/modules/profile/providers/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import Provider

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final int _selectedIndex = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildMovieRecommendations();
      default:
        return _buildMovieRecommendations();
    }
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
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
        ],
      ),
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Movie recommendations list items
          _buildMovieTile(
              'assets/The_Last_Knight.png',
              'Transformers: The Last Knight',
              'A deadly threat from Earth\'s history reappears and a hunt for a lost artifact takes place between Autobots and Decepticons, while Optimus Prime encounters his creator in space.'),
          _buildMovieTile('assets/SEAL_Team.png', 'SEAL Team',
              'The lives of the elite Navy SEALs as they train, plan, and execute the most dangerous, high-stakes missions the United States of America can ask.'),
          _buildMovieTile('assets/The_Dark_Knight.png', 'The Dark Knight',
              'When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness.'),
          _buildMovieTile(
              'assets/Avengers_ Infinity_War.png',
              'Avengers: Infinity War',
              'The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.'),
        ],
      ),
    );
  }

  Widget _buildMovieTile(String imagePath, String title, String description) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 150,
        child: Transform.scale(
          scale: 2.6,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/BG_BELAKANG_HOME.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildPage(_selectedIndex),
      ),
    );
  }
}
