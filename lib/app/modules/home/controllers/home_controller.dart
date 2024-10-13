import 'package:flutter/material.dart';

class HomeController {
  Widget buildPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return buildMovieRecommendations(context);
      default:
        return buildMovieRecommendations(context);
    }
  }

  Widget buildMovieRecommendations(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Movie recommendations list items
        buildMovieTile(
            context,
            'assets/The_Last_Knight.png', 
            'Transformers: The Last Knight',
            'A deadly threat from Earth\'s history reappears and a hunt for a lost artifact takes place between Autobots and Decepticons, while Optimus Prime encounters his creator in space.'),
        buildMovieTile(
            context,
            'assets/SEAL_Team.png',
            'SEAL Team',
            'The lives of the elite Navy SEALs as they train, plan, and execute the most dangerous, high-stakes missions the United States of America can ask.'),
        buildMovieTile(
            context,
            'assets/The_Dark_Knight.png',
            'The Dark Knight',
            'When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness.'),
        buildMovieTile(
            context,
            'assets/Avengers_ Infinity_War.png',
            'Avengers: Infinity War',
            'The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.'),
      ],
    );
  }

  Widget buildMovieTile(BuildContext context, String imagePath, String title, String description) {
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
}
