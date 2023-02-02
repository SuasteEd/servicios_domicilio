import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:servicios_domicilio/main.dart';

//Consultas de datos almacenados en SharedPreferences

//Obtener las coordenadas
LatLng getCurrentLatLngSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

int getIdSharedPrefs() {
  return sharedPreferences.getInt('id')!;
}

String getTokenUserSharedPrefs() {
  return sharedPreferences.getString('token')!;
}

bool getIsLoginSharedPrefs() {
  return sharedPreferences.getBool('isLogin') ?? false;
}

String getUserNameSharedPrefs() {
  return sharedPreferences.getString('username')!;
}

String getPasswordNameSharedPrefs() {
  return sharedPreferences.getString('password')!;
}

String getServicioDireccionSharedPref() {
  return sharedPreferences.getString('direccion')!;
}
