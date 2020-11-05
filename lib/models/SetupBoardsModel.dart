import 'package:anon4_board/storage/app_database.dart';
import 'package:anon4_board/storage/boards_table.dart';

class SetupBoardsModel {
  Future<List<BoardData>> boardDataList;
  List<BoardData> dataList;

  SetupBoardsModel() {
    createDataBaseHandle();
    boardDataList = getBoardDataList();
    _setDataList();
  }

  Future<List<BoardData>> getList() async {
    return await boardDataList;
  }

  void _setDataList() async {
    dataList = await boardDataList;
  }

  void updateList(int oldIndex, int newIndex) async {
    BoardData tempData = dataList[oldIndex];
    dataList.removeAt(oldIndex);
    dataList.insert(newIndex, tempData);
  }

  void saveToDataBase() {
    refillBoardTableData(dataList);
  }
}
