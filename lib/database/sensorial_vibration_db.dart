import 'package:sqflite/sqflite.dart';
import 'package:ic_app/database/database_service.dart';
import 'package:ic_app/model/protocols.dart';

class SensorialVibrationDB {
  final tableName = 'protocols';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "amplitude" INTEGER NOT NULL,
    "time" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "percentageUP" INTEGER NOT NULL,
    "percentageDOWN" INTEGER NOT NULL,
    "reversions" INTEGER NOT NULL,
    PRIMARY KEY ("id" AUTOINCREMENT)
  );""");
  }

  Future<int> create(
      {required name,
      amplitude,
      time,
      type,
      percentageUP,
      percentageDOWN,
      reversions}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (name,amplitude,time,type,percentageUP,percentageDOWN,reversions) VALUES (?,?,?,?,?,?,?)''',
      [name, amplitude, time, type, percentageUP, percentageDOWN, reversions],
    );
  }

  Future<List<Protocols>> fetchAll() async {
    final database = await DatabaseService().database;
    final protocols = await database.rawQuery('''SELECT * from $tableName''');
    return protocols
        .map((protocols) => Protocols.fromSqfliteDatabase(protocols))
        .toList();
  }

  Future<Protocols> fetchById(int id) async {
    final database = await DatabaseService().database;
    final protocols = await database
        .rawQuery('''SELECT * FROM $tableName WHERE id = ?''', [id]);
    return Protocols.fromSqfliteDatabase(protocols.first);
  }

  Future<int> update(
      {required int id,
      String? name,
      amplitude,
      time,
      type,
      percentageUP,
      percentageDOWN,
      reversions}) async {
    final database = await DatabaseService().database;
    return await database.update(
        tableName,
        {
          if (name != null) 'name': name,
          'amplitude': amplitude,
          'time': time,
          'type': type,
          'percentageUP': percentageUP,
          'percentageDOWN': percentageDOWN,
          'reversions': reversions
        },
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
