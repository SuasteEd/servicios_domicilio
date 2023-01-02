import 'dart:io';

import 'package:get/get.dart';
import 'package:servicios_domicilio/repository/data_source_repository.dart';
import 'package:servicios_domicilio/services/tecnico_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiciosController extends GetxController {
  final servicios = <ServicioElement>[].obs;
  final connection = false.obs;
  late int id;
  late SharedPreferences logindata;
  @override
  void onInit() async {
    logindata = await SharedPreferences.getInstance();
    init();
    super.onInit();
  }

  init() {
    id = logindata.getInt('id')!;
  }

  Future<void> getServicio() async {
    servicios.clear();
    await internet();
    final newServicio = await Get.find<DataSourceRepository>().getServicio(id);
    newServicio.forEach((element) {
      servicios.insert(0, element);
    });
  }

  Future<void> internet() async {
    try {
      final resultado = await InternetAddress.lookup('google.com');
      if (resultado.isNotEmpty && resultado[0].rawAddress.isNotEmpty) {
        connection.value = true;
      } else {
        connection.value = false;
      }
    } catch (e) {
      print('Error: $e');
      connection.value = false;
    }
  }
}
