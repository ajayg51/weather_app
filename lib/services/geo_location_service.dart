import 'package:geolocator/geolocator.dart';

class GeoLocation {
  static Future<Position> getDeviceLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      Future.error("Geo location service is not enabled");
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error("Geo location permission got denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error("Geo location permission got denied permanently");
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
