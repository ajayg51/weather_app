import 'package:geocoding/geocoding.dart';

class GeoLocationInfo {
  double latitude;
  double longitude;
  Placemark place;
  GeoLocationInfo({
    required this.latitude,
    required this.longitude,
    required this.place,
  });
}
