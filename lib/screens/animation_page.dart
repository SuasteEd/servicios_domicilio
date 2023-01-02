import 'package:flutter/material.dart';
import 'package:servicios_domicilio/models/static_tecnicos.dart';
import 'package:servicios_domicilio/widgets/custom_get_list.dart';

import '../models/tecnico_model.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  int current = 0;
  late List<Tecnico> complete = [];
  // final List<Tecnico> onCurse = [];
  // final List<Tecnico> cancel = [];
  @override
  void initState() {
    complete = tecnicos.where((element) => element.estado == 3).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: CustomGetList()));
  }
}
