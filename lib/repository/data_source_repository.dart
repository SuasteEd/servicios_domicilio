import 'package:servicios_domicilio/data_source/data_reponse.dart';
import 'package:servicios_domicilio/services/tecnico_response.dart';

class DataSourceRepository {
  final DataResponse _response;
  DataSourceRepository(this._response);

  Future<List<ServicioElement>> getServicio(int id) async {
    List<ServicioElement> servicio = await _response.getServicio(id);
    return servicio;
  }

  Future<Tecnico> getTec(int id) async {
    Tecnico tec = await _response.getTec(id);
    return tec;
  }
}
