import 'package:flutter/material.dart';
import 'package:servicios_domicilio/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (_) => const HomePage(),
    'login': (_) => const LoginPage(),
    'detalle': (_) => const DetallePage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }
}
