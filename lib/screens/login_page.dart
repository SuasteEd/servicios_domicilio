import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:servicios_domicilio/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/servicios_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool tap = false;
  String token = '';
  int id = 0;
  bool isLogin = false;
  late SharedPreferences logindata;
  final controller = Get.put(ServiciosController());

  void initData() async {
    logindata = await SharedPreferences.getInstance();
    isLogin = logindata.getBool('isLogin') ?? false;
    if (isLogin) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }
  }

  @override
  void initState() {
    initData();
    controller.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: size.height * 0.30,
                child: Container(
                  alignment: Alignment.center,
                  width: 180,
                  height: 180,
                  child: const FadeInImage(
                    image: AssetImage('assets/logo.png'),
                    placeholder: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: size.height * 0.8,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                  ),
                  color: AppTheme.primary),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Inicio de sesión',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInput(
                    size: size,
                    labelText: 'Usuario',
                    icon: Icons.account_circle,
                    obscureText: false,
                    controller: username,
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomInput(
                    size: size,
                    labelText: 'Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: password,
                    type: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      if (validaciones()) {
                        login();
                      }
                    },
                    child: Container(
                      width: size.width - 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: tap
                            ? loading()
                            : Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  color:
                                      isLogin ? Colors.white : AppTheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loading() {
    if (isLogin) {
      return const Icon(
        Icons.done,
        color: Colors.white,
        size: 40,
      );
    }
    return const CircularProgressIndicator();
  }

  void login() async {
    // if (controller.connection.isFalse) {
    //   QuickAlert.show(
    //     context: context,
    //     title: 'Oh, no...',
    //     confirmBtnText: 'Ok',
    //     type: QuickAlertType.warning,
    //     text: 'No tienes conexión a internet',
    //   );
    //   tap = false;
    // }
    var bodyReq =
        jsonEncode({'username': username.text, 'password': password.text});
    var url =
        Uri.https('serviciosdomicilio.azurewebsites.net', '/api/Account/Login');
    var response = await http.post(url, body: bodyReq, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      token = body["token"];
      id = body["usuarioId"];
      isLogin = true;
      controller.id = id;
      setState(() {});
      logindata.setInt('id', id);
      logindata.setString('token', token);
      logindata.setBool('isLogin', isLogin);
      logindata.setString('username', username.text);
      logindata.setString('password', password.text);
      if (token.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }
    } else {
      tap = false;
      QuickAlert.show(
        context: context,
        title: 'Oops...',
        confirmBtnText: 'Ok',
        type: QuickAlertType.error,
        text: 'Usuario o contraseña incorrectos',
      );
    }
  }

  bool validaciones() {
    if (username.text.isEmpty || password.text.isEmpty) {
      QuickAlert.show(
        context: context,
        title: 'Oops...',
        confirmBtnText: 'Ok',
        type: QuickAlertType.error,
        text: 'Completa todos los campos',
      );
      return false;
    }
    tap = true;
    return true;
  }
}
