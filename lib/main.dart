import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';
import 'package:servicios_domicilio/data_source/data_reponse.dart';
import 'package:servicios_domicilio/repository/data_source_repository.dart';
import 'package:servicios_domicilio/router/app_routes.dart';
import 'package:servicios_domicilio/services/push_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/network_service.dart';

//Creación de sharedPreferences global
late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Iniciar sharedPreferences global
  sharedPreferences = await SharedPreferences.getInstance();
  //
  await PushNotificationService.initializeApp();
  //Initialize DataSource
  final rest = DataResponse();
  //Create reposotory and pass it DataSource and database.
  final repository = DataSourceRepository(rest);
  //Repository inyection.
  Get.put(repository);
  //Initialize controller
  ServiciosController().onInit();
  //
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Key para navegación global.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //Key para messenger Scaffold.
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    //Listener de notificaciones
    PushNotificationService.messageStream.listen((message) {
      //Acciones que se pueden hacer según las notificaciones
      //print('MyApp: $message');
      // final snackBar = SnackBar(content: Text(message));
      // navigatorKey.currentState?.pushNamed('loading', arguments: message);
      // scaffoldKey.currentState?.showSnackBar(snackBar);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //StreamProvider para escuchar los cambios en el estado de la red de manera global.
        StreamProvider(
            create: (_) => NetworkService().controller.stream,
            initialData: NetworkStatus.online),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Servicios a domicilio app',
        theme: ThemeData(),
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
