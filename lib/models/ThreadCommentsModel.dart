import '../data/api_thread_comments.dart';

class ThreadCommentsModel  {

  String title, boardSymbol;
  int threadNo;

  ThreadCommentsModel(String title, int threadNo, String symbol) {
    this.title = title;
    this.threadNo = threadNo;
    this.boardSymbol = symbol;
  }

  Future<List<Post>> getThreadComments() async {
    return await getCommentList(this.boardSymbol, this.threadNo);
  }
}