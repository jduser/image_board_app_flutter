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

    dbase.insert('boards', map);
  }

  //print(listMap[1]);
}

Future<List<BoardData>> getBoardDataList() async {
  Database dbase = await db;
  List<Map<String, dynamic>> maps = await dbase.query('boards');
  List<BoardData> boardDataList = new List<BoardData>();
  for (var map in maps) {
    BoardData boardData = new BoardData();
    boardData.name = map['name'];
    boardData.prevSymbol = map['prevSymbol'];
    boardData.symbol = map['symbol'];
    boardDataList.add(boardData);
  }
  return boardDataList;
}

void updateBoardTableData() {}

class BoardData {
  String name;
  String symbol;
  String prevSymbol;
}
