import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/controllers/servicios_controller.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late SharedPreferences logindata;
  final controller = Get.put(ServiciosController());

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  const Center(
                    child: FadeInImage(
                      image: AssetImage('assets/logo.png'),
                      placeholder: AssetImage('assets/loading.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  controller.tecnico.isEmpty
                      ? const Text(
                          'user', //controller.tecnico[0].nombre,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.blueGrey),
                        )
                      : Text(
                          controller.tecnico[0]
                              .nombre, //controller.tecnico[0].nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.blueGrey),
                        )
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              "Cerrar sesion",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              logindata.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
