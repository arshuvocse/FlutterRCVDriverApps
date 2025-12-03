import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/update_driver_user_request.dart';
import '../routes/app_routes.dart';
import '../services/user_service.dart';

class PromotionsController extends ChangeNotifier {
  PromotionsController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isUpdatingPassword = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    isConfirmVisible = !isConfirmVisible;
    notifyListeners();
  }

  String? validatePasswords() {
    if (passwordCtrl.text.trim().isEmpty) {
      return 'Password is required';
    }
    if (confirmCtrl.text.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (passwordCtrl.text.trim() != confirmCtrl.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<bool> updatePassword() async {
    final error = validatePasswords();
    if (error != null) {
      return false;
    }
    if (isUpdatingPassword) return false;
    isUpdatingPassword = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) {
        return false;
      }
      final req = UpdateDriverUserRequest(
        driverUserId: userId,
        password: passwordCtrl.text.trim(),
      );
      final res = await _userService.updateDriverUser(req);
      return res.isSuccess;
    } catch (_) {
      return false;
    } finally {
      isUpdatingPassword = false;
      notifyListeners();
    }
  }

  void goToLocation(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.chooseLocation);
  }

  void goToBank(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.updateBank);
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }
}
