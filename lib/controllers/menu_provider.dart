import 'package:flutter/material.dart';


class MenuProvider with ChangeNotifier{

   bool expand=false;

   double menuWidth=70;
  void switchMenu(){
    expand=!expand;
    if(menuWidth==70) {
      menuWidth=200;
    } else {
      menuWidth=70;
    }
    notifyListeners();
  }

  

}