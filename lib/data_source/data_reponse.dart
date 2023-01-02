import 'package:servicios_domicilio/services/tecnico_response.dart';
import 'package:http/http.dart' as http;

class DataResponse {
  final url = Uri.parse(
      'https://serviciosdomicilio.azurewebsites.net/api/Servicio/ServiciosTecnico?usuarioId=');
  late List<ServicioElement> servicio = [];

  Future<List<ServicioElement>> getServicio(int id) async {
    final response = await http.get(
        Uri.parse(
            'https://serviciosdomicilio.azurewebsites.net/api/Servicio/ServiciosTecnico?usuarioId=$id'),
        headers: {"content-type": "application/json"});
    var data = Servicio.fromJson(response.body);
    servicio = data.servicios;
    return servicio;
  }
}
