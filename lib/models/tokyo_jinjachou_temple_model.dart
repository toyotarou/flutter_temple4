class TokyoJinjachouTempleModel {
  TokyoJinjachouTempleModel({
    required this.city,
    required this.url,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory TokyoJinjachouTempleModel.fromJson(Map<String, dynamic> json) => TokyoJinjachouTempleModel(
        city: json['city'].toString(),
        url: json['url'].toString(),
        name: json['name'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
      );
  String city;
  String url;
  String name;
  String address;
  String lat;
  String lng;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'city': city, 'url': url, 'name': name, 'address': address, 'lat': lat, 'lng': lng};
}
