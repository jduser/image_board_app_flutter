import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getBoardsList() async {
  Map<String, dynamic> boardsMap = await fetchJson();

  List<Map<String, dynamic>> boardList = boardsMap['boards'];

  return boardList;
}

Future fetchJson() async {
  http.Response response = await http.get('https://a.4cdn.org/boards.json');
  if (response.statusCode == 200) {
    //print (response.body);
    return json.decode(response.body);
  } else {
    throw http.ClientException('failed to load the JSON data');
  }
}
