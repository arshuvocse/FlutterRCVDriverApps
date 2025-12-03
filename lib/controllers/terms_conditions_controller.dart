import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/term_condition.dart';
import '../services/user_service.dart';

class TermsConditionsController extends ChangeNotifier {
  TermsConditionsController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  List<TermCondition> terms = [];
  bool isLoading = false;

  Future<void> init() async {
    await loadTerms();
  }

  Future<void> loadTerms() async {
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) {
        terms = [];
      } else {
        terms = await _userService.getDriverTermsConditionList(userId);
      }
    } catch (_) {
      terms = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
