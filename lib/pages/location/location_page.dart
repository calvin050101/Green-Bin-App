import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_bin/models/recycling_center.dart';
import 'package:green_bin/pages/location/recycling_center_detail_page.dart';

import '../../providers/recycling_center_provider.dart';

class LocationsPage extends ConsumerStatefulWidget {
  const LocationsPage({super.key});

  @override
  ConsumerState<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends ConsumerState<LocationsPage> {
  GoogleMapController? mapController;
  LatLng? _currentLocation; // To store user's current location

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

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String _formatDistance(double? meters) {
    if (meters == null) return 'N/A';
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    final recyclingCentersAsyncValue = ref.watch(recyclingCentersProvider);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: recyclingCentersAsyncValue.when(
        data: (centers) {
          Set<Marker> markers = {};
          LatLng initialCameraPosition =
              _currentLocation ?? const LatLng(5.3468, 100.2798);

          // Add markers for each recycling center
          for (var center in centers) {
            markers.add(
              Marker(
                markerId: MarkerId(center.id),
                position: LatLng(center.latitude, center.longitude),
                infoWindow: InfoWindow(
                  title: center.name,
                  snippet: _formatDistance(center.distance),
                ),
                onTap: () {
                  // Optionally animate map to center if tapped
                  mapController?.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(center.latitude, center.longitude),
                    ),
                  );
                },
              ),
            );
          }

          // If current location is available, also add a marker for it
          if (_currentLocation != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: _currentLocation!,
                infoWindow: const InfoWindow(title: 'Your Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ), // Blue marker for current location
              ),
            );

            // If no centers found, center map on current location
            if (centers.isEmpty) {
              initialCameraPosition = _currentLocation!;
            }
          }

          return Column(
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

              _mapContainer(initialCameraPosition, markers),

              const SizedBox(height: 16.0),

              // List of Recycling Centers
              Expanded(
                child:
                    centers.isEmpty
                        ? const Center(
                          child: Text(
                            'No recycling centers found nearby. Try adjusting your search radius or location.',
                            textAlign: TextAlign.center,
                          ),
                        )
                        : ListView.builder(
                          itemCount: centers.length,
                          itemBuilder:
                              (context, index) =>
                                  recyclingCenterCard(centers[index]),
                        ),
              ),
            ],
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error:
            (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading recycling centers: ${error.toString()}\n'
                  'Please check your internet connection and Google Places API key/permissions.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
      ),
    );
  }

  Container _mapContainer(LatLng initialCameraPosition, Set<Marker> markers) {
    return Container(
      height: 250, // Fixed height for the map
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialCameraPosition,
            zoom: 12.0, // Adjust zoom level as needed
          ),
          markers: markers,
          myLocationEnabled: true,
          // Show user's location dot
          myLocationButtonEnabled: true,
          // Show button to center on user
          zoomControlsEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
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
              'Distance: ${_formatDistance(center.distance)}',
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
              arguments: center
            );
          },
        ),
      ),
    );
  }
}
