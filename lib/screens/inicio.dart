import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicios_domicilio/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/servicios_controller.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

final controller = Get.put(ServiciosController());

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late SharedPreferences logindata;
    Future<bool> initData() async {
      logindata = await SharedPreferences.getInstance();
      var isLogin = logindata.getBool('isLogin') ?? false;
      if (isLogin) return true;
      return false;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder(
        future: initData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomePage(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginPage(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
          }
          return Container();
        },
      ),
    );
  }
}
