# adress_book

A Flutter project on google map.

As my API is not paid so google place API is not working currently but yet i haev implemented to pick up the place from the search bar.
i have used google_place package. yet i have also implemented som other methods.
saving those other methods here to use further.

Future<List<PlaceSearch>> getAutoCompleteResult(String searchValue) async{

    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchValue&types=(cities)&language=pt_BR&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['prediction'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<SelectedLocation> getPlace(String placeId) async{

    String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result']['geometry']['location'];
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

