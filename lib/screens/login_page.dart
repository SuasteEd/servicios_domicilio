import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:servicios_domicilio/helpers/shared_prefs.dart';
import 'package:servicios_domicilio/main.dart';
import 'package:servicios_domicilio/theme/app_theme.dart';
import 'package:servicios_domicilio/widgets/widgets.dart';

import '../controllers/servicios_controller.dart';
import '../services/network_service.dart';

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
  final controller = Get.put(ServiciosController());
  final storage = const FlutterSecureStorage();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final FocusNode focusUser = FocusNode();
  final FocusNode focusPass = FocusNode();
  void initData() async {
    isLogin = getIsLoginSharedPrefs();
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
      key: scaffoldKey,
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
                    placeholder: AssetImage('assets/moto.gif'),
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
                  FadeInDown(
                    child: const Text(
                      'Inicio de sesión',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInLeft(
                    child: CustomInput(
                      size: size,
                      labelText: 'Usuario',
                      icon: Icons.account_circle,
                      obscureText: false,
                      controller: username,
                      type: TextInputType.emailAddress,
                      focus: focusUser,
                      editing: () {
                        requestFocus(context, focusPass);
                      },
                      action: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInLeft(
                    child: CustomInput(
                      size: size,
                      labelText: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      controller: password,
                      type: TextInputType.text,
                      focus: focusPass,
                    ),
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
                    child: FadeInUp(
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
                                    color: isLogin
                                        ? Colors.white
                                        : AppTheme.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      await sendToken(id);
      sharedPreferences.setInt('id', id);
      sharedPreferences.setString('token', token);
      sharedPreferences.setBool('isLogin', isLogin);
      sharedPreferences.setString('username', username.text);
      sharedPreferences.setString('password', password.text);
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

  Future<void> sendToken(int id) async {
    final tokenAccess = await storage.read(key: 'token');
    final url = Uri.parse(
        "https://serviciosdomicilio.azurewebsites.net/api/Account/ActualizaTokenPush?usuarioId=$id&token=$tokenAccess");
    var res = await http.patch(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    if (res.statusCode == 200) {
      //print('True');
    } else {
      //print('False');
    }
  }

  bool validaciones() {
    final connection = Provider.of<NetworkStatus>(context, listen: false);
    if (connection == NetworkStatus.offline) {
      QuickAlert.show(
        context: context,
        title: 'No tienes conexión a internet',
        confirmBtnText: 'Ok',
        type: QuickAlertType.error,
        text: 'Intenta más tarde',
      );
      return false;
    }
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

  void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
