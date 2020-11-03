import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database;
String path;

void createDataBaseHandle() async {
  WidgetsFlutterBinding.ensureInitialized();

  var databasesPath = await getDatabasesPath();

  path = join(databasesPath, 'app_database.db');

  database = openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE boards(symbol TEXT, name TEXT, prevSymbol TEXT)",
      );
    },
  );
}

Future<Database> getDataBaseHandle() {
  createDataBaseHandle();
  return database;
}
