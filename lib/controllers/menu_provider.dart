import 'package:flutter/material.dart';

class MenuProvider{

  static bool expand=false;
  
  static double menuWidth=70;
  static void switchMenu(){
    expand=!expand;
    if(menuWidth==70) {
      menuWidth=200;
    } else {
      menuWidth=70;
    }
  }
  

}