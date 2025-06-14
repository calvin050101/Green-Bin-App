import 'package:flutter_google_maps_webservices/places.dart';

const String googlePlacesApiKey = 'AIzaSyAoGQ_zpJHqQIYPhgLdgGjTC0IOXlb7c2w';

class RecyclingCenter {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  double? distance;
  final String? photoUrl;
  final List<String> openingHours;

  RecyclingCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.distance,
    this.photoUrl,
    this.openingHours = const [],
  });

  // Factory constructor to convert PlacesSearchResult to RecyclingCenter
  factory RecyclingCenter.fromPlaceSearch(PlacesSearchResult result) {
    return RecyclingCenter(
      id: result.placeId,
      name: result.name,
      address: result.vicinity ?? result.formattedAddress ?? 'N/A',
      // Use vicinity or formattedAddress
      latitude: result.geometry!.location.lat,
      longitude: result.geometry!.location.lng,
      phoneNumber: null,
      // Phone number requires Place Details API
      distance: null,
      // Distance needs to be calculated manually or derived
      photoUrl:
          result.photos.isNotEmpty == true
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${result.photos.first.photoReference}&key=$googlePlacesApiKey'
              : null,
      openingHours: result.openingHours?.weekdayText ?? [],
    );
  }
}
