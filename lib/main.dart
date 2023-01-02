import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';
import 'package:servicios_domicilio/data_source/data_reponse.dart';
import 'package:servicios_domicilio/repository/data_source_repository.dart';
import 'package:servicios_domicilio/router/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize DataSource
  final rest = DataResponse();
  //Create reposotory and pass it DataSource and database.
  final repository = DataSourceRepository(rest);
  //Repository inyection.
  Get.put(repository);
  ServiciosController().onInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Servicios a domicilio app',
      theme: ThemeData(),
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
