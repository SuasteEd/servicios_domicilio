import 'dart:convert';

class Servicio {
  Servicio({
    required this.tecnico,
    required this.servicios,
  });

  Tecnico tecnico;
  List<ServicioElement> servicios;

  factory Servicio.fromJson(String str) => Servicio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Servicio.fromMap(Map<String, dynamic> json) => Servicio(
        tecnico: Tecnico.fromMap(json["tecnico"]),
        servicios: List<ServicioElement>.from(
            json["servicios"].map((x) => ServicioElement.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "tecnico": tecnico.toMap(),
        "servicios": List<dynamic>.from(servicios.map((x) => x.toMap())),
      };
}

class ServicioElement {
  ServicioElement({
    required this.folio,
    required this.cliente,
    required this.estado,
    required this.fecha,
    required this.horario,
    required this.telefono,
    required this.domicilio,
  });

  int folio;
  String cliente;
  int estado;
  DateTime fecha;
  String horario;
  String telefono;
  String domicilio;

  factory ServicioElement.fromJson(String str) =>
      ServicioElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServicioElement.fromMap(Map<String, dynamic> json) => ServicioElement(
        folio: json["folio"],
        cliente: json["cliente"],
        estado: json["estado"],
        fecha: DateTime.parse(json["fecha"]),
        horario: json["horario"],
        telefono: json["telefono"],
        domicilio: json["domicilio"],
      );

  Map<String, dynamic> toMap() => {
        "folio": folio,
        "cliente": cliente,
        "estado": estado,
        "fecha": fecha.toIso8601String(),
        "horario": horario,
        "telefono": telefono,
        "domicilio": domicilio,
      };
}

class Tecnico {
  Tecnico({
    required this.nombre,
    required this.fotografia,
  });

  String nombre;
  String fotografia;

  factory Tecnico.fromJson(String str) => Tecnico.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tecnico.fromMap(Map<String, dynamic> json) => Tecnico(
        nombre: json["nombre"],
        fotografia: json["fotografia"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "fotografia": fotografia,
      };
}
