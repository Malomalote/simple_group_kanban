import 'package:flutter/material.dart';

class CardStateProvider{

  static GlobalKey<FormState> stateGlobalKey= GlobalKey<FormState>();

  static String nameState='';
  static String descriptionState='';
  static bool cardStateFormValid=true;
  static bool newcardState=false;

}