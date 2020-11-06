import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database database;
String path;

Future<void> createDataBaseHandle() async {
  WidgetsFlutterBinding.ensureInitialized();

  var databasesPath = await getDatabasesPath();

  path = join(databasesPath, 'app_database.db');

  database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      return await db.execute(
        "CREATE TABLE boards(symbol TEXT, name TEXT, prevSymbol TEXT, nextSymbol TEXT, show TEXT)",
      );
    },
  );
}

Future<Database> getDataBaseHandle() async {
  await createDataBaseHandle();
  return database;
}
