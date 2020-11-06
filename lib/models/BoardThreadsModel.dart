import 'package:flutter/material.dart';
import '../data/api_board_threads.dart';
import 'package:anon4_board/storage/boards_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:anon4_board/storage/app_database.dart';

class BoardThreadsModel extends ChangeNotifier {
  String boardSymbol;
  Future<List<BoardData>> boardList;

  BoardThreadsModel() {
    _setBoardList();
  }

  void _setBoardList() async {
    List<BoardData> bList;
    Database dbase = await getDataBaseHandle();
    this.boardList = getBoardDataList(dbase);
    bList = await this.boardList;
    this.boardSymbol = bList[0].symbol;
  }

  void setBoard(String symbol) {
    this.boardSymbol = symbol;
    notifyListeners();
  }

  Future<List<OPThread>> getBoardCatalog(String newBoard) async {
    this.boardSymbol = newBoard;
    return await opThreadList(this.boardSymbol);
  }
}
