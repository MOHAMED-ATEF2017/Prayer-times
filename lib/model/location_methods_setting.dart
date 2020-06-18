class LocationAndMethods {


  final int id ;

  final String name;

  LocationAndMethods({this.id, this.name});

  factory LocationAndMethods.fromJson(Map<String, dynamic> json) => _locationAndMethodsFromMap(json);

}
LocationAndMethods _locationAndMethodsFromMap(Map<String, dynamic> json) {


  return LocationAndMethods(
    id: json ["id"] as int,
    name: json ["name"] as String,
  );
}