import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_bin/widgets/form/loading_error.dart';

import '../../helper/list_view_functions.dart';
import '../../providers/recycling_center_provider.dart';
import '../../widgets/card/recycling_center_card.dart';

class LocationsPage extends ConsumerStatefulWidget {
  const LocationsPage({super.key});

  @override
  ConsumerState<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends ConsumerState<LocationsPage> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Get user's initial location
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recyclingCentersAsyncValue = ref.watch(recyclingCentersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Recycling Locations',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),

      body: recyclingCentersAsyncValue.when(
        data: (centers) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listVerticalItems(
                  centers,
                  (context, center) => RecyclingCenterCard(center: center),
                  'No recycling centers found nearby. Try adjusting your search radius or location.',
                ),
              ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error:
            (error, stack) => LoadingError(
              error:
                  'Error loading recycling centers: ${error.toString()}\n'
                  'Please check your internet connection and Google Places API key/permissions.',
            ),
      ),
    );
  }
}
