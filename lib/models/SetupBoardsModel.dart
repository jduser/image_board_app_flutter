import 'dart:async';

import 'package:anon4_board/storage/app_database.dart';
import 'package:anon4_board/storage/boards_table.dart';
import 'package:sqflite/sqflite.dart';

class SetupBoardsModel {
  Future<List<BoardData>> boardDataList;
  List<BoardData> dataList;
  Future<Database> db;

  SetupBoardsModel() {
    this.db = getDataBaseHandle();
    _setDataList();
  }

  Future<List<BoardData>> getList() async {
    return await this.boardDataList;
  }

  void _setDataList() async {
    Database dbase = await this.db;
    this.boardDataList = getBoardDataList(dbase);
    this.dataList = await this.boardDataList;
    //print('DATALIST is $dataList');
  }

  Future<void> updateList(int oldIndex, int newIndex) async {
    this.dataList = await this.boardDataList;
    BoardData tempData = dataList[oldIndex];
    dataList.removeAt(oldIndex);
    dataList.insert(newIndex, tempData);
  }

  Future<void> saveToDataBase() async {
    Database dbase = await this.db;
    this.dataList = await this.boardDataList;
    await refillBoardTableData(dataList, dbase);
  }
}
