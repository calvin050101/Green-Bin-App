import 'package:flutter_google_maps_webservices/places.dart';
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
    this.photoUrl
  });

  // Factory constructor to convert PlacesSearchResult to RecyclingCenter
  factory RecyclingCenter.fromPlaceSearch(PlacesSearchResult result) {
    if (result.geometry == null) {
      throw ArgumentError(
        'PlacesSearchResult is missing geometry or location data.',
      );
    }

    return RecyclingCenter(
      id: result.placeId,
      name: result.name,
      address: result.vicinity ?? result.formattedAddress ?? 'N/A',
      latitude: result.geometry!.location.lat,
      longitude: result.geometry!.location.lng,
      distance: null,
      // Distance needs to be calculated manually or derived
      photoUrl:
          result.photos.isNotEmpty == true
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${result.photos.first.photoReference}&key=$googlePlacesApiKey'
              : null,
    );
  }
}
