library flickere.globals;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

double lat = 23.7747;
double lng = 90.3655;

AppBar defaultAppBar =  AppBar(
  backgroundColor: Colors.blueAccent[100],
  title: Text('Address Book'),
);

List<Placemark> placeMarks = [];

Map placeDetails = {};