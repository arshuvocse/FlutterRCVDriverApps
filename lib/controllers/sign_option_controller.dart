import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class SignOptionController extends ChangeNotifier {
  final Duration _typingDelay = const Duration(milliseconds: 100);
  final Duration _restartDelay = const Duration(seconds: 2);
  final String fullText = 'Welcome! Ready to sign in or register?';

  String typingText = '';
  Timer? _typingTimer;
  bool _disposed = false;

  Future<void> init(BuildContext context) async {
    _startTypingLoop();
    await _checkForUserPreferences(context);
  }

  void _startTypingLoop() {
    _typingTimer?.cancel();
    typingText = '';
    int index = 0;

    _typingTimer = Timer.periodic(_typingDelay, (timer) {
      if (_disposed) return;
      if (index < fullText.length) {
        typingText += fullText[index];
        index++;
        notifyListeners();
      } else {
        timer.cancel();
        Future.delayed(_restartDelay, () {
          if (_disposed) return;
          _startTypingLoop();
        });
      }
    });
  }

  Future<void> _checkForUserPreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final pkid = prefs.getInt('UserId') ?? 0;
    final mobile = prefs.getString('m_no') ?? '';
    if (pkid != 0 && mobile.isNotEmpty) {
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (_) => false,
      );
    }
  }

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.getStarted);
  }

  void onSignIn(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  void onSignUp(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.scanEmiratesId);
  }

  @override
  void dispose() {
    _disposed = true;
    _typingTimer?.cancel();
    super.dispose();
  }
}
