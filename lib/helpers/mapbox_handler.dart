import 'package:mapbox_gl/mapbox_gl.dart';
import '../data_source/mapbox_response.dart';

//Manejador de las consultas a las APIs de Mapbox
//
//Método que procesa la consulta del API de Mapbox de rutas
Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response = await getRouteUsingMapBox(sourceLatLng, destinationLatLng);
  //Mapa de coordenas que se usará para determinar y dibujar la polyline.
  Map geometry = response['routes'][0]['geometry'];
  //Distancia
  num duration = response['routes'][0]['duration'];
  //Duración
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

//Método para determinar el centro del mapa según el origen y el destino
LatLng getCenterCoordinatesForPolyline(Map geometry) {
  List coordinates = geometry['coordinates'];
  int pos = (coordinates.length / 2).round();

  return LatLng(coordinates[pos][1], coordinates[pos][0]);
}
