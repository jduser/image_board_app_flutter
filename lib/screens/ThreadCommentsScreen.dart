import 'package:anon4_board/screens/widgets/ParseComment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ThreadCommentsModel.dart';
import '../data/api_thread_comments.dart';
import 'util/common_functions.dart';
import 'DisplayAttachScreen.dart';

class ThreadCommentsScreen extends StatelessWidget {
  static const routeName = 'ShowThread';
  ThreadCommentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowThreadData routeArgs = ModalRoute.of(context).settings.arguments;
    int threadNo;
    String boardSymbol;
    String title;

    threadNo = routeArgs.threadNo;
    boardSymbol = routeArgs.boardSymbol;
    title = routeArgs.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Provider(
          create: (context) =>
              ThreadCommentsModel(title, threadNo, boardSymbol),
          child: Consumer<ThreadCommentsModel>(
              builder: (context, comments, child) {
            return FutureBuilder<List<Post>>(
                future: comments.getThreadComments(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return snapshot.hasData
                      ? ShowComment(
                          commentList: snapshot.data, boardSymbol: boardSymbol)
                      : Center(child: CircularProgressIndicator());
                });
          })),
    );
  }
}

class ShowThreadData {
  int threadNo;
  String title;
  String boardSymbol;
  ShowThreadData({this.threadNo, this.title, this.boardSymbol});
}

class ShowComment extends StatelessWidget {
  final List<Post> commentList;
  final String boardSymbol;
  ShowComment({Key key, this.commentList, this.boardSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
          itemCount: commentList.length,
          itemBuilder: (context, index) {
            String comment = commentList[index].com;
            bool hasImage = false;
            String tim = commentList[index].tim.toString();
            String tims = tim + 's';
            String tnImage = ' ';
            if (tim != '0') {
              hasImage = true;
              tnImage =
                  "https://i.4cdn.org/" + boardSymbol + "/" + tims + ".jpg";
            } else {
              hasImage = false;
            }

            return Column(children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    FutureBuilder<Widget>(
                        future: getImage(tnImage),
                        builder: (context, snapshot) {
                          Widget result;
                          if (hasImage == true) {
                            if (snapshot.hasError) {
                              result = Icon(Icons.broken_image);
                            }
                            if (snapshot.hasData) {
                              result = snapshot.data;
                            } else {
                              result = Icon(Icons.broken_image);
                            }
                            result = InkWell(
                              child: Container(
                                  child: result, height: 75, width: 75),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, DisplayAttachScreen.routeName,
                                    arguments: FileInfo(
                                        data: commentList[index],
                                        board: boardSymbol));
                              },
                            );
                          } else {
                            result = Text('');
                          }
                          return result;
                        }),
                    Column(
                      children: <Widget>[
                        Text(commentList[index].no.toString()),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ]),
                  Column(children: <Widget>[
                    //Text(comment)
                    ParseComment(comment: comment)
                  ]),
                ],
              ),
              Divider()
            ]);
          },
        ),
      );    
  }
}
