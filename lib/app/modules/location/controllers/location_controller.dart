import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import for geocoding

class LocationController extends GetxController {
  RxList<Map<String, dynamic>> cinemaLocations = <Map<String, dynamic>>[
    {
      "name": "Cinepolis Malang Town Square",
      "address":
          "Jl. Veteran No.2 Unit UA-03, Penanggungan, Klojen, Malang City, East Java 65111",
      "latitude": -7.956240599804503,
      "longitude": 112.61843610902713
    },
    {
      "name": "Transmart MX XXI",
      "address":
          "Mall Transmart, Jl. Veteran Lt. 5, Penanggungan, Kec. Klojen, Kota Malang, Jawa Timur 65113",
      "latitude": -7.955906731852613,
      "longitude": 112.61834733971368
    },
    {
      "name": "Cinépolis Lippo Plaza Batu",
      "address":
          "4 Lippo Plaza Batu, Sisir, Kec. Batu, Kota Batu, Jawa Timur 65314",
      "latitude": -7.878743330777748,
      "longitude": 112.53474211272747
    },
    {
      "name": "CGV Cinemas Malang City Point",
      "address":
          "Malang City Point, Jl. Terusan Dieng, Pisang Candi, Kec. Sukun, Kota Malang, Jawa Timur 65146",
      "latitude": -7.973451189378541,
      "longitude": 112.61246299314695
    },
    {
      "name": "Araya XXI",
      "address":
          "Komp. Araya Bussines Center, lantai 2, Jl. Blimbing Indah Megah No.2, Purwodadi, Kec. Blimbing, Kota Malang, Jawa Timur 65126",
      "latitude": -7.9365649489242305,
      "longitude": 112.65113870663893
    },
    {
      "name": "Dieng XXI",
      "address":
          "Dieng Plaza Lantai 3, Jl. Raya Langsep No. 2, Pisang Candi, Malang, Malang City, East Java 65147",
      "latitude": -7.973529990281486,
      "longitude": 112.6123999955349
    },
    {
      "name": "Movimax Dinoyo City",
      "address":
          "Jl. MT. Haryono No.193, Dinoyo, Kec. Lowokwaru, Kota Malang, Jawa Timur 65144",
      "latitude": -7.937768429023017,
      "longitude": 112.6076486540018
    },
    {
      "name": "Mandala XXI",
      "address":
          "Plaza Malang, Jl. Agus Salim No.28, Sukoharjo, Kec. Klojen, Kota Malang, Jawa Timur 65118",
      "latitude": -7.9841787946997735,
      "longitude": 112.63357639499779
    },
    {
      "name": "CGV Grand Indonesia",
      "address": "Jl. M.H. Thamrin, Jakarta",
      "latitude": -6.194527,
      "longitude": 106.822744,
    },
    {
      "name": "Blitz Megaplex Pacific Place",
      "address": "Jl. Jend. Sudirman, Jakarta",
      "latitude": -6.225154,
      "longitude": 106.809881,
    },
    // Add other cinemas here...
  ].obs;

  RxList<Map<String, dynamic>> nearbyCinemas = <Map<String, dynamic>>[].obs;
  Rx<Position?> userPosition = Rx<Position?>(null);
  RxString userAddress = ''.obs; // To store the user's address or city

  @override
  void onReady() {
    super.onReady();
    refreshLocation();
  }

  Future<void> refreshLocation() async {
    await _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Error',
        'Location permissions are permanently denied. We cannot request permissions.',
      );
      return;
    }

    // Get the current position
    userPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // Use high accuracy

    // Handle fallback if position is still null
    if (userPosition.value == null) {
      Get.snackbar('Error', 'Unable to fetch location.');
      return;
    }

    // Fetch the user's address
    await _getAddressFromCoordinates();

    // Find nearby cinemas
    _findNearbyCinemas();
  }

  Future<void> _getAddressFromCoordinates() async {
    if (userPosition.value == null) {
      print('User position is null. Cannot fetch address.');
      userAddress.value = 'Location not available';
      return;
    }

    final latitude = userPosition.value!.latitude;
    final longitude = userPosition.value!.longitude;

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        print('No placemarks found for coordinates.');
        userAddress.value = 'Address not found';
      } else {
        final Placemark place = placemarks.first;

        // Safely access fields with null-checking
        final locality = place.locality ?? 'Unknown locality';
        final administrativeArea =
            place.administrativeArea ?? 'Unknown administrative area';
        final country = place.country ?? 'Unknown country';

        userAddress.value = "$locality, $administrativeArea, $country";
        print('Address: ${userAddress.value}');
      }
    } catch (e) {
      print("Error fetching address: $e");
      userAddress.value = 'Error fetching address';
    }
  }

  void _findNearbyCinemas() {
    if (userPosition.value == null) return;

    const double maxDistance = 15000; // Max distance in meters (15 km)
    Position currentPosition = userPosition.value!;

    nearbyCinemas.value = cinemaLocations.where((cinema) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        cinema['latitude'],
        cinema['longitude'],
      );
      return distance <= maxDistance;
    }).toList();
  }
}
