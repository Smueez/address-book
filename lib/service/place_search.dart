class PlaceSearch {

  String description,
      placeId;

  PlaceSearch({
    required this.description,
    required this.placeId
  });

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['description'],
        placeId: json['place_id']
    );
  }
}