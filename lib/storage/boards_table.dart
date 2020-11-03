import 'package:anon4_board/storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

Future<List<BoardData>> getBoardDataList() async {
  Database dbase = await getDataBaseHandle();

  List<Map<String, dynamic>> maps = await dbase.query('boards');
  List<BoardData> boardDataList = new List<BoardData>();
  for (var map in maps) {
    BoardData boardData = new BoardData.fromMap(map);
    boardDataList.add(boardData);
  }
  return boardDataList;
}

void updateBoardTableData() {}

void deleteBoardTableData() {}

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
