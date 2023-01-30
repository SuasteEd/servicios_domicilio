import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:servicios_domicilio/helpers/shared_prefs.dart';
import '../constants/constants.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = mapboxToken;
String navType = 'driving';
String direction = '';
Dio _dio = Dio();

Future getCoordinatebyNameUsingMapBox() async {
  direction = getServicioDireccionSharedPref();
  String url =
      '$baseUrl/$direction+Leon+Guanajuato.json?access_token=$accessToken';
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    //print('url: $url');
    return responseData.data;
  } catch (e) {
    debugPrint(e.toString());
  }
}
