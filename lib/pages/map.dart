import 'dart:async';
import 'package:adress_book/service/databaseClass.dart';
import 'package:adress_book/service/location.dart';
import 'package:adress_book/service/places_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:adress_book/service/global.dart' as global;
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  var isCancelButtonShown = false,
      currentLocationOnCenterShown = true;

  Map<String, Marker> markers = {};

  var nameInputController = TextEditingController();
  var phoneInputController = TextEditingController();
  var searchInputController = TextEditingController();

  Completer<GoogleMapController> mapController = Completer();

  Map<dynamic,dynamic> data = {};
  double lat = global.lat,
      lng = global.lng;
  CameraPosition currentCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(global.lat, global.lng),
      tilt: 59.440717697143555,
      zoom: 18
  );

  List predictionsList = [];

  void goToLoc(LatLng latLng) async{ // called when tap on map

    CameraPosition tappedLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: latLng,
        tilt: 59.440717697143555,
        zoom: 18
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(tappedLocation));

    LocationClass locationClass = new LocationClass();
    locationClass.getPlaceDetails(latLng.latitude, latLng.longitude);
    markers.clear();
    setState(() {
      isCancelButtonShown = true;
      currentLocationOnCenterShown = false;
      var marker = Marker(
        markerId: MarkerId('tappedLocation'),
        position: latLng,
      );
      markers['tappedLocation'] = marker;
    });
  }

  void onCurrentLocationChanged() async{

    Location location = new Location();

    location.onLocationChanged.listen((LocationData currentLocation) async {

      // checking if current location camera needs to active
      print(currentLocationOnCenterShown);
      if(currentLocationOnCenterShown){
      // Use current location
        print('location changed');
        print(currentLocation.longitude);
        lat = double.parse(currentLocation.latitude.toString());
        lng = double.parse(currentLocation.longitude.toString());
        CameraPosition currentCameraPosition = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(lat,lng),
            tilt: 59.440717697143555,
            zoom: 18
        );
        final GoogleMapController controller = await mapController.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
        setState(() {
          LocationClass locationClass = new LocationClass();
          locationClass.getPlaceDetails(lat, lng);
        });

      }
    });

  }

  void getAutoComplete(String searchValue) async {

    print(searchValue);
    PlacesService placesServices = new PlacesService();
    predictionsList = await placesServices.getAutoComplete(searchValue);

    setState(() {
      predictionsList = predictionsList;
    });
  }

  void getPosition(String placeID) async {
    PlacesService placesServices = new PlacesService();
    LatLng latLng = await placesServices.getSelectedPlace(placeID);

    CameraPosition searchedCameraPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: latLng,
        tilt: 59.440717697143555,
        zoom: 18
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(searchedCameraPosition));

    markers.clear();
    setState(() {
      var marker = Marker(
          markerId: MarkerId(placeID),
          position: latLng,
      );
      markers['searchedMarker'] = marker;
    });
  }

  @override
  void initState() {
    super.initState();

    onCurrentLocationChanged();
     print(global.placeMarks);
  }
  @override
  Widget build(BuildContext context) {
    //print(data);
    return ProviderScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[100],
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: searchInputController,

                  onChanged: (searchValue) {
                    if(searchValue.isNotEmpty){
                      getAutoComplete(searchValue);
                    }
                    else {
                      setState(() {
                        predictionsList = [];
                      });
                    }
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                        ),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15),
                      hintText: "Search place..."),
                ),
              ),
              IconButton(
                  onPressed: (){
                    currentLocationOnCenterShown = false;
                    getAutoComplete(searchInputController.text);
                  },
                  icon: Icon(Icons.search)
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            ListView(
            primary: false,
            shrinkWrap: false,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 400,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: (Colors.blueAccent[100])!
                      )
                    )
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                        markers: markers.values.toSet(),
                        mapType: MapType.normal,
                        initialCameraPosition: currentCameraPosition,
                        onMapCreated: (GoogleMapController controller) {

                          mapController.complete(controller);
                        },

                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        onTap: goToLoc,

                      ),
                      Visibility(
                        visible: isCancelButtonShown,
                        child: Positioned(
                            left: 0,
                            bottom: 2,
                            right: 0,
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  isCancelButtonShown = false;
                                  currentLocationOnCenterShown = true;
                                  markers.clear();
                                });

                              },
                              icon: Icon(
                                  Icons.cancel_rounded,
                                  size: 40,
                                  color: Colors.blueAccent[100],
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
               ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                      child: Text(
                        'Name',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600]
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: (Colors.blue[100])!
                              )
                          )
                      ),
                      child: TextField(
                        controller: nameInputController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,

                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Write name here..."
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                      child: Text(
                        'Phone Number',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600]
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: (Colors.blue[100])!
                              )
                          )
                      ),
                      child: TextField(
                        controller: phoneInputController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Phone no..."),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600]
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${global.placeDetails['street']}, '
                                  '${global.placeDetails['name']}, '
                                  '${global.placeDetails['subLocality']}',
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  ),
                                  maxLines: 5,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'City: ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600]
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              global.placeDetails['city'],
                                              style: TextStyle(
                                                  color: Colors.grey[600]
                                              ),
                                              maxLines: 5,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Country: ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600]
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              global.placeDetails['country'],
                                              style: TextStyle(
                                                  color: Colors.grey[600]
                                              ),
                                              maxLines: 5,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async{
                          if(nameInputController.text.isEmpty || phoneInputController.text.isEmpty){
                            Fluttertoast.showToast(
                              msg: "Please provided required information",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                            );
                            return;
                          }
                          Map<dynamic,dynamic> addressInfo = {
                            'name': nameInputController.text,
                            'city': global.placeDetails['city'],
                            'country': global.placeDetails['country'],
                            'address': '${global.placeDetails['street']}, '
                                        '${global.placeDetails['name']}, '
                                        '${global.placeDetails['subLocality']}',
                            'phone': phoneInputController.text.toString(),
                            'lat': lat,
                            'lng': lng
                          };
                          DatabaseClass database = new DatabaseClass();
                          await database.insertAddress(addressInfo);
                          Future.delayed(Duration.zero, ()
                          {
                            Fluttertoast.showToast(
                                msg: "Data updated!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                            );
                            Navigator.pushNamedAndRemoveUntil(context, '/addresslist', (r) => false);
                          });
                        },
                        child: Text(
                          'Save Address',
                          style: TextStyle(
                            color: Colors.white
                          ),

                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.lightGreen[300])
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    backgroundBlendMode: BlendMode.darken,
                  ),

                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: predictionsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: (){
                            currentLocationOnCenterShown = false;
                            getPosition(predictionsList[index].placeId);
                          },
                          title: Text(
                              predictionsList[index].description,
                              style: TextStyle(
                                color: Colors.white
                              ),
                          ),
                        );
                      }
                  ),
                ),
            )
          ],
        )
      ),
    );
  }
}
