import 'package:flutter/material.dart';

class Translator extends ChangeNotifier {
  Translator._();
  static final Translator instance = Translator._();

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  String t(String key) => key;
}
