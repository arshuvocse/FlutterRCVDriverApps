import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/translator.dart';
import '../routes/app_routes.dart';

class SelectLanguageController extends ChangeNotifier {
  String selected = 'en-US';
  bool isSaving = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    selected = prefs.getString('selectedLanguage') ?? 'en-US';
    notifyListeners();
  }

  void choose(String code) {
    selected = code;
    notifyListeners();
  }

  Future<void> confirm(BuildContext context) async {
    if (isSaving) return;
    isSaving = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', selected);
      Translator.instance.setLocale(_toLocale(selected));
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.givePermission,
        (_) => false,
      );
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Locale _toLocale(String code) {
    if (code == 'ar-SY') return const Locale('ar');
    return const Locale('en');
  }
}
