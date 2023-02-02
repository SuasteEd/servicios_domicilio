import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../constants/constants.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = mapboxToken;
String navType = 'driving';

//Dio es lo mismo que el paquete http.
Dio _dio = Dio();

Future getRouteUsingMapBox(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';

  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    debugPrint(e.toString());
  }
}
