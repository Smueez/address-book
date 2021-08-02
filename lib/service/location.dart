import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adress_book/service/global.dart' as global;

class LocationClass {


  Future<Position> determinePosition() async {
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
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getPlaceDetails(double lat, double lng) async{
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);

    global.placeDetails['city'] = placeMarks[0].locality.toString();
    global.placeDetails['country'] = placeMarks[0].country.toString();
    global.placeDetails['street'] = placeMarks[0].street.toString();
    global.placeDetails['name'] = placeMarks[0].name.toString();
    global.placeDetails['subLocality'] = placeMarks[0].subLocality.toString();

  }


}