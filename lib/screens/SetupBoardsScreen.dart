import 'package:flutter/material.dart';
import 'package:anon4_board/storage/boards_table.dart';
import 'package:anon4_board/models/SetupBoardsModel.dart';
import 'package:anon4_board/models/BoardThreadsModel.dart';

class SetupBoardsScreen extends StatefulWidget {
  static const String routeName = 'SetupBoardsScreen';

  @override
  SetupBoardsScreenState createState() => SetupBoardsScreenState();
}

class SetupBoardsScreenState extends State<SetupBoardsScreen> {
  SetupBoardsModel boardModel = new SetupBoardsModel();
  Future<List<BoardData>> boardDataList;

  void initState() {
    super.initState();
    boardDataList = boardModel.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Setup Boards"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                await boardModel.saveToDataBase();
                BoardThreadsModel btm =
                    ModalRoute.of(context).settings.arguments;
                await btm.resetBoardsList();
                setState(() {});
              },
            ),
          ],
        ),
        body: FutureBuilder<List<BoardData>>(
          future: boardDataList, //boardModel.getList(),
          builder: (context, snapshot) {
            List<ListTile> tileList = new List<ListTile>();
            if (snapshot.hasData) {
              for (BoardData bd in snapshot.data) {
                String symbol = bd.symbol;
                String name = bd.name;
                ListTile tile = new ListTile(
                  key: ValueKey(symbol),
                  title: Text("/$symbol/ - $name"),
                );
                tileList.add(tile);
              }
              return ReorderableListView(
                children: [...?tileList],
                onReorder: (oldIndex, newIndex) {
                  boardModel.updateList(oldIndex, newIndex);
                  setState(() {});
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
            //return Center(child: Text("None of the above conditions"));
          },
        ));
  }
}
