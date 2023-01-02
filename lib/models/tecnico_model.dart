import 'package:flutter/cupertino.dart';

class Tecnico {
  int folio;
  String cliente;
  int estado;
  String fecha;
  String domicilio;

  Tecnico(
      {required this.folio,
      required this.cliente,
      required this.estado,
      required this.fecha,
      required this.domicilio});
}

class Horario {
  int dia;
  int diaSema;
  String horario;

  Horario({required this.dia, required this.diaSema, required this.horario});
}
