import 'package:anon4_board/data/api_get_BoardList.dart';
import 'package:anon4_board/storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

final Future boards = getBoardsList();
final Future db = getDataBaseHandle();

void main() {
  insertBoardTable();
}

void insertBoardTable() async {
  Database dbase = await db;
  List<Map<String, String>> listMap = await boards;

  String prevSymbol = '';
  for (int i = 0; i <= listMap.length; i++) {
    Map<String, String> map = new Map();

    map['symbol'] = listMap[i]['board'];
    map['name'] = listMap[i]['title'];
    map['prevSymbol'] = prevSymbol;
    prevSymbol = map['symbol'];

    await dbase.insert('boards', map);
  }

  //print(listMap[1]);
}

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

void updateBoardTableData() {}

void deleteBoardTableData() {}

class BoardData {
  String name;
  String symbol;
  String prevSymbol;

  Map<String, String> toMap() {
    Map map = new Map<String, String>();
    map['name'] = name;
    map['symbol'] = symbol;
    map['prevSymbol'] = prevSymbol;
    return map;
  }

  BoardData();

  BoardData.fromMap(Map map) {
    this.name = map['name'] ?? '';
    this.symbol = map['symbol'] ?? '';
    this.prevSymbol = map['prevSymbol'] ?? '';
  }
}
