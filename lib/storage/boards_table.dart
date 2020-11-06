import 'dart:async';
import 'package:sqflite/sqflite.dart';
//import 'package:anon4_board/storage/app_database.dart';
import 'package:anon4_board/data/api_get_BoardList.dart';

FutureOr<List<BoardData>> getBoardDataList(Database dbase) async {
  int count = Sqflite.firstIntValue(
      await dbase.rawQuery('SELECT COUNT(*) FROM boards'));

  print("ROW COUNT IS $count");

  List<BoardData> boardDataList = new List<BoardData>();
  if (count == 0) {
    await insertBoardTable(dbase);
  }

  List<Map<String, dynamic>> maps = await dbase.query('boards');
  print('boards TABLE $maps');
  for (var map in maps) {
    BoardData boardData = new BoardData.fromMap(map);
    boardDataList.add(boardData);
  }

  return boardDataList;
}

Future<void> insertBoardTable(Database db) async {
  final Future<List<Map<String, dynamic>>> boards = getBoardsList();
  List<Map<String, dynamic>> listMap = await boards;

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

/*void updateBoardTableData() async {
  List<BoardData> boardDataList = await getBoardDataList();
}*/

Future<void> refillBoardTableData(
    List<BoardData> bDataList, Database dbase) async {
  //dbase = await getDataBaseHandle();
  await dbase.rawDelete('DELETE from boards');
  List<Map<String, String>> maps;
  for (BoardData bd in bDataList) {
    maps.add(bd.toMap());
  }
  for (var map in maps) {
    await dbase.insert('boards', map);
  }
}

Future<void> noShowBoardTableData(String symbol, Database dbase) async {
  //dbase = await getDataBaseHandle();

  await dbase.rawUpdate(
      'UPDATE boards SET show = ? WHERE symbol = ?', ["false", symbol]);
}

class BoardData {
  String name;
  String symbol;
  String prevSymbol;
  String nextSymbol;
  String show;

  Map<String, String> toMap() {
    Map map = new Map<String, String>();
    map['name'] = name;
    map['symbol'] = symbol;
    map['prevSymbol'] = prevSymbol;
    map['nextSymbol'] = nextSymbol;
    map['show'] = show;
    return map;
  }

  BoardData();

  BoardData.fromMap(Map map) {
    this.name = map['name'] ?? '';
    this.symbol = map['symbol'] ?? '';
    this.prevSymbol = map['prevSymbol'] ?? '';
    this.nextSymbol = map['nextSymbol'] ?? '';
    this.show = map['show'] ?? 'true';
  }
}
