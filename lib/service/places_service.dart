import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
class PlacesService {

  String apiKey = 'AIzaSyDgRPSphvTvf2vkZhslavL_RIWIsmFisUM';

  Future<List> getAutoComplete(String searchValue) async {

    var googlePlace = GooglePlace(apiKey);
    var result = await googlePlace.autocomplete.get(searchValue);
    return result!.predictions as List ;

  }

  Future<LatLng> getSelectedPlace(String placeId) async {

    var googlePlace = GooglePlace(apiKey);
    var result = await googlePlace.details.get(placeId) as Map;
    return new LatLng(result['result']['geometry']['location']['lat'], result['result']['geometry']['location']['lng']);

  }

}