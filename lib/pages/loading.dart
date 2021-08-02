import 'package:adress_book/service/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adress_book/service/global.dart' as global;

class LoadingApp extends StatefulWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  _LoadingAppState createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp> with TickerProviderStateMixin{


  void setCurrentLocation() async{
    LocationClass locationClass = new LocationClass();

    Position currentPosition = await locationClass.determinePosition();
    List<Placemark> placeMarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
    global.placeMarks = placeMarks;
    global.placeDetails['city'] = placeMarks[0].locality.toString();
    global.placeDetails['country'] = placeMarks[0].country.toString();
    global.placeDetails['street'] = placeMarks[0].street.toString();
    global.placeDetails['name'] = placeMarks[0].name.toString();
    global.placeDetails['subLocality'] = placeMarks[0].subLocality.toString();

    global.lat = currentPosition.latitude;
    global.lng = currentPosition.longitude;
    Future.delayed(Duration.zero, ()
    {
      Navigator.pushReplacementNamed(context, '/addresslist');
    });

  }

@override
  void initState() {
    super.initState();
    setCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Scaffold(
          body: SafeArea(
            child: SpinKitFadingCube(
              color: Colors.grey[500],
              size: 50.0,
              duration: const Duration(milliseconds: 1200),
            )
          ),
      ),
    );
  }
}
