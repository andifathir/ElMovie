import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/routes/app_pages.dart';

class MovieDetailController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isFavorite = false.obs;
  RxBool isDisliked = false.obs;

  @override
  void onInit() {
    super.onInit();
    final movie =
        Get.arguments as Movie; // Assuming Movie is passed as argument
    loadMovieStatus(movie.id);
  }

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  Future<void> toggleFavorite(String movieId, String movieName) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    if (isFavorite.value) {
      // Remove favorite
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .delete();
      isFavorite.value = false;
    } else {
      // Add to favorites and remove dislike if exists
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .set({
        'movieId': movieId,
        'movieName': movieName,
      });
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .delete();
      isFavorite.value = true;
      isDisliked.value = false;
    }
  }

  Future<void> toggleDislike(String movieId, String movieName) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    if (isDisliked.value) {
      // Remove dislike
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .delete();
      isDisliked.value = false;
    } else {
      // Add to dislikes and remove favorite if exists
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .set({
        'movieId': movieId,
        'movieName': movieName,
      });
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .delete();
      isDisliked.value = true;
      isFavorite.value = false;
    }
  }

  Future<void> loadMovieStatus(String movieId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    final favoriteDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('Favorites')
        .doc(movieId)
        .get();
    final dislikeDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('Dislikes')
        .doc(movieId)
        .get();

    isFavorite.value = favoriteDoc.exists;
    isDisliked.value = dislikeDoc.exists;
  }
}

// class MovieDetailView extends GetView<MovieDetailController> {
//   final Movie movie;

//   const MovieDetailView({Key? key, required this.movie}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final MovieDetailController controller = Get.put(
//       MovieDetailController(),
//       tag: movie
//           .id, // Use a tag to differentiate controllers for different movies
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           movie.title,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: movie.thumbnail.isNotEmpty
//                       ? Image.network(
//                           movie.thumbnail,
//                           height: 250,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         )
//                       : Container(
//                           height: 250,
//                           width: double.infinity,
//                           color: Colors.grey[300],
//                           child:
//                               Icon(Icons.movie, size: 60, color: Colors.grey),
//                         ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         movie.title,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             'Year: ',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           Text(
//                             '${movie.year}',
//                             style: TextStyle(color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             'Rating: ',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           Text(
//                             '${movie.rating}',
//                             style: TextStyle(color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Description:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                       Text(
//                         movie.description,
//                         style: TextStyle(color: Colors.black87),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(() => ElevatedButton.icon(
//                         onPressed: () => controller.toggleFavorite(
//                           movie.id,
//                           movie.title,
//                         ),
//                         icon: Icon(
//                           Icons.favorite,
//                           color: controller.isFavorite.value
//                               ? Colors.red
//                               : Colors.white,
//                         ),
//                         label: Text('Favorite'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: controller.isFavorite.value
//                               ? Colors.green
//                               : Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 12,
//                           ),
//                         ),
//                       )),
//                   Obx(() => ElevatedButton.icon(
//                         onPressed: () => controller.toggleDislike(
//                           movie.id,
//                           movie.title,
//                         ),
//                         icon: Icon(
//                           Icons.thumb_down,
//                           color: controller.isDisliked.value
//                               ? Colors.blue
//                               : Colors.white,
//                         ),
//                         label: Text('Dislike'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: controller.isDisliked.value
//                               ? Colors.red
//                               : Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 12,
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//               SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Get.toNamed(Routes.REVIEW, arguments: movie);
//                 },
//                 icon: Icon(Icons.rate_review),
//                 label: Text('Add Review'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Get.toNamed(
//                     Routes.MOVIE_DETAILS_WEBVIEW,
//                     arguments: movie,
//                   );
//                 },
//                 icon: Icon(Icons.info),
//                 label: Text('Read More'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
