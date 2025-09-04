import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_bin/models/recycling_center.dart';
import 'package:green_bin/pages/location/recycling_center_detail_page.dart';
import 'package:green_bin/widgets/loading_error.dart';

import '../../helper/list_view_functions.dart';
import '../../helper/location_functions.dart';
import '../../providers/recycling_center_provider.dart';

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
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: recyclingCentersAsyncValue.when(
        data: (centers) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Recycling Locations',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                listVerticalItems(
                  centers,
                  (context, center) => recyclingCenterCard(center),
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

  Card recyclingCenterCard(RecyclingCenter center) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: ListTile(
        leading: const Icon(Icons.recycling, color: Colors.green),
        title: Text(
          center.name,
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'OpenSans'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(center.address, style: TextStyle(fontFamily: 'OpenSans')),
            Text(
              'Distance: ${formatDistance(center.distance)}',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RecyclingCenterDetailPage.routeName,
              arguments: center,
            );
          },
        ),
      ),
    );
  }
}
