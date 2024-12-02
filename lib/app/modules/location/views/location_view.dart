import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka URL
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image for the entire screen
        Positioned.fill(
          child: Image.asset(
            'assets/BG_BELAKANG_HOME.png', // Background image for the entire screen
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make the body transparent
          appBar: AppBar(
            title: const Text('Nearby Cinemas', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.transparent, // Make the AppBar transparent
            elevation: 0, // Remove AppBar shadow
          ),
          body: Obx(() {
            if (controller.userPosition.value == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.nearbyCinemas.isEmpty) {
              return const Center(
                child: Text('No nearby cinemas found.'),
              );
            }

            return Column(
              children: [
                // Header (User Position) with Background Image
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () async {
                      final lat = controller.userPosition.value!.latitude;
                      final lng = controller.userPosition.value!.longitude;

                      final googleMapsUrl = Uri.parse(
                          "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                      // Open the user's location in Google Maps
                      if (await canLaunchUrl(googleMapsUrl)) {
                        await launchUrl(googleMapsUrl,
                            mode: LaunchMode.externalApplication);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Could not open Google Maps.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade300.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Your Location: ${controller.userPosition.value!.latitude.toStringAsFixed(6)}, ${controller.userPosition.value!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // List of Nearby Cinemas
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: controller.nearbyCinemas.length,
                    itemBuilder: (context, index) {
                      final cinema = controller.nearbyCinemas[index];
                      return GestureDetector(
                        onTap: () async {
                          final lat = cinema['latitude'];
                          final lng = cinema['longitude'];

                          final googleMapsUrl = Uri.parse(
                              "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                          // Check if Google Maps can be opened
                          if (await canLaunchUrl(googleMapsUrl)) {
                            await launchUrl(googleMapsUrl,
                                mode: LaunchMode.externalApplication);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Could not open Google Maps.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cinema['name'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                cinema['address'],
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
