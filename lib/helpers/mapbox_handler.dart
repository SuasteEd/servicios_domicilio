import 'package:mapbox_gl/mapbox_gl.dart';

import '../data_source/mapbox_response.dart';

Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response = await getRouteUsingMapBox(sourceLatLng, destinationLatLng);
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

LatLng getCenterCoordinatesForPolyline(Map geometry) {
  List coordinates = geometry['coordinates'];
  int pos = (coordinates.length / 2).round();

  return LatLng(coordinates[pos][1], coordinates[pos][0]);
}
