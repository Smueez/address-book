class AddressClass {

  String id, name, city, country, address, phone;
  double lat, lng;

  AddressClass({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'country': country,
      'address': address,
      'phone': phone,
      'lat': lat,
      'lng': lng
    };
  }
  @override
  String toString(){
    return 'AddressClass{id: $id, name: $name, city: $city, country: $country, address: $address, phone: $phone, lat: $lat, lng: $lng, }';
  }
}