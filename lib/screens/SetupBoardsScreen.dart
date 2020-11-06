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

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder<List<BoardData>>(
          future: boardModel.getList(),
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
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
