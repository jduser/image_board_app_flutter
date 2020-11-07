import 'dart:async';
import 'package:anon4_board/storage/boards_table.dart';

class SetupBoardsModel {
  Future<List<BoardData>> boardDataList;

  SetupBoardsModel() {
    this.boardDataList = getBoardDataList();
  }

  Future<List<BoardData>> getList() async {
    return this.boardDataList;
  }

  Future<void> updateList(int oldIndex, int newIndex) async {
    List<BoardData> dataList = await this.boardDataList;
    BoardData tempData = dataList[oldIndex];
    dataList.removeAt(oldIndex);
    dataList.insert(newIndex, tempData);
    //return dataList;
  }

  Future<void> saveToDataBase() async {
    List<BoardData> dataList = await this.boardDataList;
    await refillBoardTableData(dataList);
  }
}
