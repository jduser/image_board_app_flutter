import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:anon4_board/data/api_get_BoardList.dart';

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
      await db.execute(
        "CREATE TABLE boards(symbol TEXT, name TEXT, prevSymbol TEXT, nextSymbol TEXT, show TEXT)",
      );
      await insertBoardTable(db);
      return null;
    },
  );
}

Future<void> insertBoardTable(Database db) async {
  final Future boards = getBoardsList();
  List<Map<String, String>> listMap = await boards;

  for (int i = 0; i < listMap.length; i++) {
    Map<String, String> map = new Map();

    map['symbol'] = listMap[i]['board'];
    map['name'] = listMap[i]['title'];
    map['prevSymbol'] = (i > 0) ? listMap[i - 1]['board'] : '';
    map['nextSymbol'] =
        ((i + 1) < listMap.length) ? listMap[i + 1]['board'] : '';
    map['show'] = 'true';

    await db.insert('boards', map);
  }
}

FutureOr<Database> getDataBaseHandle() async {
  await createDataBaseHandle();
  return database;
}
