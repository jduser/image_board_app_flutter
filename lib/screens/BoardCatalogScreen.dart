import 'package:anon4_board/screens/SetupBoardsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../models/BoardThreadsModel.dart';
import '../data/api_board_threads.dart';
import 'util/common_functions.dart';
import '../screens/ThreadCommentsScreen.dart';
import 'DisplayAttachScreen.dart';
import 'package:anon4_board/screens/widgets/ParseComment.dart';

class BoardCatalogScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BoardThreadsModel('g'),
        child: Consumer<BoardThreadsModel>(builder: (context, board, child) {
          return Scaffold(
              key: scaffoldState,
              appBar: AppBar(
                title: ShowDropDownBoardList(),
                centerTitle: true,
                actions: <Widget>[
                  /*  IconButton(icon: Icon(Icons.search),
                    onPressed: () {

                    },
                  ),*/
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      board.setBoard(board.boardSymbol);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              drawer: Drawer(
                child: Column(children: <Widget>[
                  DrawerHeader(
                    child: Text('this is the header'),
                  ),
                  GestureDetector(
                    child: ListTile(title: Text('Setup Boards')),
                    onTap: () {
                      Navigator.pushNamed(context, SetupBoardsScreen.routeName);
                    },
                  ),
                  ListTile(title: Text('Bookmarks'))
                ]),
              ),
              body: FutureBuilder<List<OPThread>>(
                  future: board.getBoardCatalog(board.boardSymbol),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    return snapshot.hasData
                        ? ShowOPComment(
                            opCommentList: snapshot.data,
                            boardSymbol: board.boardSymbol)
                        : Center(child: CircularProgressIndicator());
                  }));
        }));
  }
}

class ShowOPComment extends StatelessWidget {
  final List<OPThread> opCommentList;
  final String boardSymbol;
  ShowOPComment({Key key, this.opCommentList, this.boardSymbol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: Consumer<BoardThreadsModel>(builder: (context, board, child) {
      return RefreshIndicator(
        child: ListView.builder(
          key: ObjectKey(boardSymbol),
          itemCount: opCommentList.length,
          itemBuilder: (context, index) {
            String comment = opCommentList[index].com;
            String tims = opCommentList[index].tim.toString() + 's';
            String tnImage =
                "https://i.4cdn.org/" + boardSymbol + "/" + tims + ".jpg";

            String subject = opCommentList[index].sub;
            int threadNo = opCommentList[index].no;

            return Column(children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    InkWell(
                      child: Container(
                          child: FutureBuilder<Widget>(
                            future: getImage(tnImage),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Icon(Icons.broken_image);
                              }
                              if (snapshot.hasData) {
                                return snapshot.data;
                              } else {
                                return Icon(Icons.broken_image);
                              }
                            },
                          ),
                          width: 75,
                          height: 75),
                      onTap: () {
                        Navigator.pushNamed(
                            context, DisplayAttachScreen.routeName,
                            arguments: FileInfo(
                                data: opCommentList[index],
                                board: boardSymbol));
                      },
                    ),
                    InkWell(
                      child: Column(
                        children: <Widget>[
                          Text(opCommentList[index].no.toString()),
                          Text("Replies: " +
                              opCommentList[index].replies.toString() +
                              ", " +
                              "Images: " +
                              opCommentList[index].images.toString()),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, ThreadCommentsScreen.routeName,
                            arguments: ShowThreadData(
                                title: subject,
                                threadNo: threadNo,
                                boardSymbol: boardSymbol));
                      },
                    ),
                  ]),
                  InkWell(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ConstrainedBox(
                              //child: Text(comment),
                              child: ParseComment(comment: comment),
                              constraints: BoxConstraints(maxHeight: 300))
                          //FittedBox(child: Text(comment))
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                      constraints: BoxConstraints(maxHeight: 350.0),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, ThreadCommentsScreen.routeName,
                          arguments: ShowThreadData(
                              title: subject,
                              threadNo: threadNo,
                              boardSymbol: boardSymbol));
                    },
                  ),
                ],
              ),
              Divider()
            ]);
          },
        ),
        onRefresh: () {
          board.setBoard(board.boardSymbol);
          return Future.value();
        },
      );
    }));
  }
}

class ShowDropDownBoardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List boardList = Provider.of<BoardThreadsModel>(context).boardList;
    List<DropdownMenuItem<String>> menuList = new List();
    for (int i = 0; i < boardList.length; i++) {
      Map m = boardList[i];
      String boardDesc = m['title'];
      String bs = m['board_ln'];

      menuList.add(DropdownMenuItem<String>(
          value: bs,
          child: Container(
            child: Text(
              "/$bs/ - $boardDesc",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            width: double.infinity,
          )));
    }

    return Consumer<BoardThreadsModel>(builder: (context, board, child) {
      return DropdownButton<String>(
        isExpanded: true,
        value: board.boardSymbol,
        items: menuList,
        onChanged: (newVal) {
          board.setBoard(newVal);
        },
      );
    });
  }
}
