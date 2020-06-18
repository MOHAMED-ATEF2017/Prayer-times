class LocationQueryAutoComplete {
  final String description;
  final String mainText;
  final String secondaryText;

  final String placeID;
  LocationQueryAutoComplete( {this.description, this.placeID,this.mainText, this.secondaryText});

  factory LocationQueryAutoComplete.fromJson(Map<String, dynamic> json) => _locationQueryAutoCompleteFromMap(json);

}
LocationQueryAutoComplete _locationQueryAutoCompleteFromMap(Map<String, dynamic> json) {


  return LocationQueryAutoComplete(
    description: json["predictions"]["description"] as String,
    mainText: json["predictions"]["structured_formatting"]["main_text"] as String,
    secondaryText: json ["predictions"]["structured_formatting"]["secondary_text"] as String,
    placeID: json ["predictions"]["place_id"] as String,


  );
}