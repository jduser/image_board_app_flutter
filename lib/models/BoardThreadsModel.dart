import 'package:flutter/material.dart';
import '../data/api_board_threads.dart';
import 'package:anon4_board/storage/boards_table.dart';

class BoardThreadsModel extends ChangeNotifier {
  String boardSymbol;
  Future<List<BoardData>> boardsList = getBoardDataList();

  BoardThreadsModel() {
    _setBoardsList();
  }

  Future<void> _setBoardsList() async {
    List<BoardData> bList;
    bList = await this.boardsList;
    this.setBoard(bList[0].symbol);
  }

  void setBoard(String symbol) {
    this.boardSymbol = symbol;
    notifyListeners();
  }

  Future<void> resetBoardsList() async {
    this.boardsList = getBoardDataList();
    List<BoardData> bList;
    bList = await this.boardsList;
    this.setBoard(bList[0].symbol);
  }

  Future<List<OPThread>> getBoardCatalog(String newBoard) async {
    this.boardSymbol = newBoard;
    return await opThreadList(this.boardSymbol);
  }
}
