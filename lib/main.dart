import 'package:flutter/material.dart';
import 'package:anon4_board/models/AppThemeStyleModel.dart';
import 'package:anon4_board/screens/DisplayAttachScreen.dart';
import 'package:provider/provider.dart';
import 'screens/BoardCatalogScreen.dart';
import 'screens/ThreadCommentsScreen.dart';
import 'package:anon4_board/screens/SetupBoardsScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppThemeStyleModel(),
        child: MaterialApp(
          title: 'Anon4 Board',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: TextTheme(bodyText2: TextStyle(fontSize: 18)),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => BoardCatalogScreen(),
            ThreadCommentsScreen.routeName: (context) => ThreadCommentsScreen(),
            DisplayAttachScreen.routeName: (context) => DisplayAttachScreen(),
            SetupBoardsScreen.routeName: (context) => SetupBoardsScreen()
          },
        ));
  }
}
