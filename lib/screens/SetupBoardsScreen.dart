import 'package:flutter/material.dart';
import 'package:anon4_board/storage/boards_table.dart';
import 'package:anon4_board/models/SetupBoardsModel.dart';

class SetupBoardsScreen extends StatefulWidget {
  static const String routeName = 'SetupBoardsScreen';

  @override
  SetupBoardsScreenState createState() => SetupBoardsScreenState();
}

class SetupBoardsScreenState extends State<SetupBoardsScreen> {
  SetupBoardsModel boardModel = new SetupBoardsModel();
  List<BoardData> boardList;

  SetupBoardsScreenState() {
    _setBoardList();
  }

  void _setBoardList() async {
    this.boardList = await boardModel.getList();
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> tileList = new List();

    for (BoardData bd in boardList) {
      String symbol = bd.symbol;
      String name = bd.name;
      ListTile tile = new ListTile(
        key: ValueKey(symbol),
        title: Text("/$symbol/ - $name"),
      );
      tileList.add(tile);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Boards"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              boardModel.saveToDataBase();
            },
          ),
        ],
      ),
      body: ReorderableListView(
        children: [...?tileList],
        onReorder: (oldIndex, newIndex) {
          boardModel.updateList(oldIndex, newIndex);
        },
      ),
    );
  }
}
