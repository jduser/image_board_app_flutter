import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/*main() async {
  final Future<List<Map<String, dynamic>>> boards = getBoardsList();
  List<Map<String, dynamic>> listMap = await boards;

  print ('the list is $listMap');
}*/


Future<List<Map<String, dynamic>>> getBoardsList() async {
  var boardsMap = await fetchJson();

  List<Map<String, dynamic>> boardList = List<Map<String, dynamic>>.from(boardsMap['boards']);

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
