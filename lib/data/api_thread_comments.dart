import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Post>> getCommentList(String boardSymbol, int threadNo) async {

  Map data = await fetchData('https://a.4cdn.org/' + boardSymbol + '/thread/' + threadNo.toString() + '.json');
  List dataList = data['posts'];
  List commentList = new List<Post>();

  for (int i = 0; i < dataList.length; i++) {
    Map comment = dataList[i];
    commentList.add(Post.fromJson(comment));
  }

  return commentList;
}

Future fetchData(String url) async {
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    //print (response.body);
    return json.decode(response.body);
  } else {
    throw http.ClientException('failed to load the JSON data');
  }
}

class Post {
  int no;
  String now;
  String name;
  String sub;
  String com;
  String filename;
  String ext;
  int w;
  int h;
  int tnW;
  int tnH;
  int tim;
  int time;
  String md5;
  int fsize;
  int resto;
  int bumplimit;
  int imagelimit;
  String semanticUrl;
  int replies;
  int images;
  int uniqueIps;
  int tailSize;

  Post();

  Post.fromJson(Map<String, dynamic> json) {
    no = fixNullint(json['no']);
    now = fixNullStr(json['now']);
    name = fixNullStr(json['name']);
    sub = fixNullStr(json['sub']);
    com = fixNullStr(json['com']);
    filename = fixNullStr(json['filename']);
    ext = fixNullStr(json['ext']);
    w = fixNullint(json['w']);
    h = fixNullint(json['h']);
    tnW = fixNullint(json['tn_w']);
    tnH = fixNullint(json['tn_h']);
    tim = fixNullint(json['tim']);
    time = fixNullint(json['time']);
    md5 = fixNullStr(json['md5']);
    fsize = fixNullint(json['fsize']);
    resto = fixNullint(json['resto']);
    bumplimit = fixNullint(json['bumplimit']);
    imagelimit = fixNullint(json['imagelimit']);
    semanticUrl = fixNullStr(json['semantic_url']);
    replies = fixNullint(json['replies']);
    images = fixNullint(json['images']);
    uniqueIps = fixNullint(json['unique_ips']);
    tailSize = fixNullint(json['tail_size']);
  }

  String fixNullStr(String str) {
    if (str == null) str = "";
    return str;
  }

  int fixNullint(int i) {
    if (i == null) i = 0;
    return i;
  }
}
