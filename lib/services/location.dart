import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

Future<String> getUserLocation() async {
  //call this async method from whereever you need

  // ignore: unused_local_variable
  String error;
  Position? position;
  Placemark address;
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  try {
    position = await Geolocator.getLastKnownPosition();
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'please grant permission';
      // ignore: avoid_print
      // print(error);
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      error = 'permission denied- please enable it from app settings';
      // ignore: avoid_print
      // print(error);
    }
  }
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position!.latitude, position.longitude);

  // ignore: avoid_print
  address = placemarks.last;
  // ignore: avoid_print
  String? street = address.street;
  String? sublocality = address.subLocality;
  String? locality = address.locality;
  String? state = address.administrativeArea;
  String? country = address.country;
  String? pincode = address.postalCode;
  String userLocation =
      '$street, $sublocality, $locality, $state, $country, $pincode';
  // ignore: avoid_print
  return userLocation;
}
