import 'package:flutter_google_maps_webservices/places.dart';
import 'package:latlong2/latlong.dart';
import '../api_keys.dart';

class RecyclingCenter {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  double? distance;
  final String? photoUrl;

  RecyclingCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.photoUrl,
  });

  // Getter for safe distance access
  double get effectiveDistance => distance ?? double.infinity;

  // Update distance from current location
  void updateDistanceFrom(LatLng currentLocation) {
    final distanceCalculator = const Distance();
    distance = distanceCalculator.as(
      LengthUnit.Meter,
      currentLocation,
      LatLng(latitude, longitude),
    );
  }

  // Factory constructor to convert PlacesSearchResult to RecyclingCenter
  factory RecyclingCenter.fromPlaceSearch(PlacesSearchResult result) {
    if (result.geometry == null) {
      throw ArgumentError(
        'PlacesSearchResult is missing geometry or location data.',
      );
    }

    var recyclingCenter = RecyclingCenter(
      id: result.placeId,
      name: result.name,
      address: result.vicinity ?? result.formattedAddress ?? 'N/A',
      latitude: result.geometry!.location.lat,
      longitude: result.geometry!.location.lng,
      distance: null,
      photoUrl:
          result.photos.isNotEmpty == true
              ? Uri.https('maps.googleapis.com', '/maps/api/place/photo', {
                'maxwidth': '400',
                'photoreference': result.photos.first.photoReference,
                'key': googlePlacesApiKey,
              }).toString()
              : null,
    );

    return recyclingCenter;
  }
}
