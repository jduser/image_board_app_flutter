import 'package:flutter/material.dart';
import '../data/api_board_threads.dart';
import 'package:anon4_board/storage/boards_table.dart';

class BoardThreadsModel extends ChangeNotifier {
  String boardSymbol;
  List<BoardData> boardList;

  BoardThreadsModel() {
    _setBoardList();
  }

  void _setBoardList() async {
    this.boardList = await getBoardDataList();
    this.boardSymbol = this.boardList[0].symbol;
  }

  void setBoard(String symbol) {
    this.boardSymbol = symbol;
    notifyListeners();
  }

  Future<List<OPThread>> getBoardCatalog(String newBoard) async {
    boardSymbol = newBoard;
    return await opThreadList(boardSymbol);
  }
}
