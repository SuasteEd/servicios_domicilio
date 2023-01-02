import 'package:sqflite/sqflite.dart';

class DataBaseConnection {
  late Database _database;

  static initDataBase() async {
    return await openDatabase('db_crud.db', version: 1,
        onCreate: (db, version) {
      db.execute(createDataBase());
    });
  }

  static String createDataBase() {
    return 'CREATE IF NOT EXISTS servicios(nombre TEXT, fotografia TEXT, folio INT , cliente TEXT, estado TEXT, fecha DATETIME, horario TEXT, telefono TEXT, domicilio TEXT)';
  }

  void close() {
    _database.close();
  }
}
