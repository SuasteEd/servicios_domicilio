import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

String urlBase = 'serviciosdomicilio.azurewebsites.net/';

void onRoad(int id, LatLng coordenadas, int time) {
  final Uri url = Uri.https(urlBase, 'api/Servicio/EnCamino');
  http.patch(
    url,
    body: {
      'ServicioId': id,
      'Latitud': coordenadas.latitude,
      'Longitud': coordenadas.longitude,
      'ETAMin' : time
    }
  );
}
