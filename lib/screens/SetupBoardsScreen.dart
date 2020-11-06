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
            print("INSIDE THE BUILDER FUNCTION");
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("CONNECTION WAITING");
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              return Text(snapshot.error);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              for (BoardData bd in snapshot.data) {
                String symbol = bd.symbol;
                String name = bd.name;
                print("INSIDE THE FOR LOOP OF BOARDMODEL SNAPSHOT");
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
            }
            return Center(child: Text("No Data"));
          },
        ));
  }
}
