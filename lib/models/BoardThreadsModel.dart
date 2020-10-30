import 'package:flutter/material.dart';
import '../data/api_board_threads.dart';
import '../data/BoardList.dart';


class BoardThreadsModel extends ChangeNotifier {

  String boardSymbol;
  List boardList;

  BoardThreadsModel(String symbol) {
    this.boardSymbol = symbol;
    this.boardList = BoardList.getList();
  }

  void setBoard (String symbol) {
    this.boardSymbol = symbol;
    notifyListeners();
  }

  Future<List<OPThread>> getBoardCatalog(String newBoard) async {
    boardSymbol = newBoard;
    return await opThreadList(boardSymbol);
  }
}
