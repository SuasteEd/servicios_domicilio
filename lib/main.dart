import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';
import 'package:servicios_domicilio/data_source/data_reponse.dart';
import 'package:servicios_domicilio/repository/data_source_repository.dart';
import 'package:servicios_domicilio/router/app_routes.dart';
import 'package:servicios_domicilio/services/push_notifications.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    PushNotificationService.messageStream.listen((message) {
      print('MyApp: $message');
      navigatorKey.currentState?.pushNamed('home');
    });
  }

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
