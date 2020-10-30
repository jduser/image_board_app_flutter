import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<List<OPThread>> opThreadList(String boardSymbol) async {
  List data = await fetchData('https://a.4cdn.org/' + boardSymbol + '/catalog.json');

  List opThreadList = new List<OPThread>();

  for (int i = 0; i < data.length; i++) {
    Map page = data[i];
    List threads = page["threads"];
    for (int j = 0; j < threads.length; j++) {
      opThreadList.add(OPThread.fromJson(threads[j]));
      //if (opThreadList[j].com == null) {}
    }
  }
  return opThreadList;
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

class OPThread {
  int no;
  int sticky;
  int closed;
  String now;
  String name;
  String com;
  String filename;
  String ext;
  String sub;
  int w;
  int h;
  int tnW;
  int tnH;
  int tim;
  int time;
  String md5;
  int fsize;
  int resto;
  String capcode;
  String semanticUrl;
  int replies;
  int images;

  OPThread();

  OPThread.fromJson(Map<String, dynamic> json) {
    no = fixNullint(json['no']);
    sticky = fixNullint(json['sticky']);
    closed = fixNullint(json['closed']);
    now = fixNullStr(json['now']);
    name = fixNullStr(json['name']);
    com = fixNullStr(json['com']);
    filename = fixNullStr(json['filename']);
    ext = fixNullStr(json['ext']);
    sub = fixNullStr(json['sub']);
    w = fixNullint(json['w']);
    h = fixNullint(json['h']);
    tnW = fixNullint(json['tn_w']);
    tnH = fixNullint(json['tn_h']);
    tim = fixNullint(json['tim']);
    time = fixNullint(json['time']);
    md5 = fixNullStr(json['md5']);
    fsize = fixNullint(json['fsize']);
    resto = fixNullint(json['resto']);
    capcode = fixNullStr(json['capcode']);
    semanticUrl = fixNullStr(json['semantic_url']);
    replies = fixNullint(json['replies']);
    images = fixNullint(json['images']);
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
