import 'dart:convert';

class Tecnico {
    Tecnico({
        required this.tecnico,
        required this.servicios,
    });

    TecnicoClass tecnico;
    dynamic servicios;

    factory Tecnico.fromJson(String str) => Tecnico.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tecnico.fromMap(Map<String, dynamic> json) => Tecnico(
        tecnico: TecnicoClass.fromMap(json["tecnico"]),
        servicios: json["servicios"],
    );

    Map<String, dynamic> toMap() => {
        "tecnico": tecnico.toMap(),
        "servicios": servicios,
    };
}

class TecnicoClass {
    TecnicoClass({
        required this.nombre,
        required this.fotografia,
    });

    String nombre;
    String fotografia;

    factory TecnicoClass.fromJson(String str) => TecnicoClass.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TecnicoClass.fromMap(Map<String, dynamic> json) => TecnicoClass(
        nombre: json["nombre"],
        fotografia: json["fotografia"],
    );

    Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "fotografia": fotografia,
    };
}
