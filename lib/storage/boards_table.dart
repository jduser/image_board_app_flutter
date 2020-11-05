import 'package:anon4_board/storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> db = getDataBaseHandle();

Future<List<BoardData>> getBoardDataList() async {
  Database dbase = await db;

  List<Map<String, dynamic>> maps = await dbase.query('boards');
  List<BoardData> boardDataList = new List<BoardData>();
  for (var map in maps) {
    BoardData boardData = new BoardData.fromMap(map);
    boardDataList.add(boardData);
  }
  return boardDataList;
}

/*void updateBoardTableData() async {
  List<BoardData> boardDataList = await getBoardDataList();
}*/

void refillBoardTableData(List<BoardData> bDataList) async {
  Database dbase = await db;
  dbase.rawDelete('DELETE from boards');
  List<Map<String, String>> maps;
  for (BoardData bd in bDataList) {
    maps.add(bd.toMap());
  }
  for (var map in maps) {
    dbase.insert('boards', map);
  }
}

void noShowBoardTableData(String symbol) async {
  Database dbase = await db;

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
