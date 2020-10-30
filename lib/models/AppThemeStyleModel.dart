import 'package:flutter/material.dart';


class AppThemeStyleModel extends ChangeNotifier {

  int bodyFontSize;
  
  AppThemeStyleModel() {
    this.bodyFontSize = 14;
  }

  set bodyFontsize (int num) {
    this.bodyFontSize = num;
    notifyListeners();
  }
}