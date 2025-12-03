import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController countryCodeCtrl =
      TextEditingController(text: '+971');
  final TextEditingController mobileCtrl = TextEditingController();

  bool isSubmitting = false;

  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;
    final mobile = mobileCtrl.text.trim();
    if (mobile.isEmpty) {
      _showSnack(context, 'Please enter a mobile number.');
      return;
    }

    isSubmitting = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: wire to OTP API / navigation to OTP page.
      if (!context.mounted) return;
      _showSnack(context, 'OTP request sent (stub).');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void onBack(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    countryCodeCtrl.dispose();
    mobileCtrl.dispose();
    super.dispose();
  }
}
