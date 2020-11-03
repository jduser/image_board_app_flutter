import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/*main() async {
  Map<String, dynamic> boardsMap = await fetchJson();

  List boardList = boardsMap['boards'];

  print('static List boardList = [\n');

  for (int i = 0; i < boardList.length; i++) {
    Map<String, dynamic> board = boardList[i];
    print('{');
    print('"board_ln": "' + board['board'] + '",');
    print('"title": "' + board['title'] + '"');
    print('},');
  }
  print('];');
}*/

Future getBoardsList() async {
  Map<String, dynamic> boardsMap = await fetchJson();

  List boardList = boardsMap['boards'];

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
