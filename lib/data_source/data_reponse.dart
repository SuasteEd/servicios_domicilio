import 'package:servicios_domicilio/services/tecnico_response.dart';
import 'package:http/http.dart' as http;

class DataResponse {
  late List<ServicioElement> servicio = [];
  late Tecnico tecnico;

  Future<List<ServicioElement>> getServicio(int id) async {
    final response = await http.get(
        Uri.parse(
            'https://serviciosdomicilio.azurewebsites.net/api/Servicio/ServiciosTecnico?usuarioId=$id'),
        headers: {"content-type": "application/json"});
    var data = Servicio.fromJson(response.body);
    servicio = data.servicios;
    return servicio;
  }

  Future<Tecnico> getTec(int id) async {
    final response = await http.get(
        Uri.parse(
            'https://serviciosdomicilio.azurewebsites.net/api/Servicio/ServiciosTecnico?usuarioId=$id'),
        headers: {"content-type": "application/json"});
    var data = Servicio.fromJson(response.body);
    tecnico = data.tecnico;
    return tecnico;
  }
}
