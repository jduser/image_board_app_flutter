import 'dart:async';

import 'package:anon4_board/storage/app_database.dart';
import 'package:anon4_board/storage/boards_table.dart';
import 'package:sqflite/sqflite.dart';

class SetupBoardsModel {
  Future<List<BoardData>> boardDataList;
  Future<Database> db;

  SetupBoardsModel() {
    this.db = getDataBaseHandle();
    _setDataList();
  }

  Future<List<BoardData>> getList() async {
    print("ENTERING GETlIST");
    return await this.boardDataList;
  }

  void _setDataList() async {
    Database dbase = await this.db;
    this.boardDataList = getBoardDataList(dbase);
    print("EXITING SETDATAlIST");
  }

  Future<void> updateList(int oldIndex, int newIndex) async {
    List<BoardData> dataList = await this.boardDataList;
    BoardData tempData = dataList[oldIndex];
    dataList.removeAt(oldIndex);
    dataList.insert(newIndex, tempData);
  }

  Future<void> saveToDataBase() async {
    Database dbase = await this.db;
    List<BoardData> dataList = await this.boardDataList;
    await refillBoardTableData(dataList, dbase);
  }
}
