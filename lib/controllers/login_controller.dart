import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../models/device_info_request.dart';
import '../models/sign_in_request.dart';
import '../routes/app_routes.dart';
import '../services/user_service.dart';

class LoginController extends ChangeNotifier {
  LoginController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  final TextEditingController countryCodeCtrl =
      TextEditingController(text: '+971');
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isSubmitting = false;

  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;
    final mobile = mobileCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    if (mobile.isEmpty || password.isEmpty) {
      _showSnack(context, 'Please enter mobile and password');
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      final request = SignInRequest(
        mobileNumber: '${countryCodeCtrl.text.trim()}$mobile',
        password: password,
      );
      final response = await _userService.signIn(request);
      if (response.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('UserId', response.pkid);
        await prefs.setString('m_no', response.errorMessage.isNotEmpty ? response.errorMessage : request.mobileNumber);
        await prefs.setString('FullName', response.errorMessageNew);
        await prefs.setInt('UserIdSignOut', 0);

        await _sendDeviceInfo(response.pkid);

        if (!context.mounted) return;
        _showSnack(context, 'Sign In Successfully!');
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (_) => false,
        );
      } else {
        if (!context.mounted) return;
        _showSnack(context, 'User not found');
      }
    } catch (_) {
      if (!context.mounted) return;
      _showSnack(context, 'Something went wrong');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> _sendDeviceInfo(int userId) async {
    try {
      final info = DeviceInfoPlugin();
      String deviceId = 'unknown';
      String deviceModel = '';
      String os = '';
      String osVersion = '';
      final package = await PackageInfo.fromPlatform();

      // Basic device info; adjust per platform if needed
      final android = await info.androidInfo;
      deviceId = android.id;
      deviceModel = android.model;
      os = 'Android';
      osVersion = android.version.release;

      final deviceReq = DeviceInfoRequest(
        driverUserId: userId,
        deviceId: deviceId,
        deviceModel: deviceModel,
        operatingSystem: os,
        osVersion: osVersion,
        appVersion: package.version,
        deviceToken: '', // TODO: wire FCM token
        fcmToken: '',
      );
      await _userService.saveDriverDeviceInfo(deviceReq);
    } catch (_) {}
  }

  void onForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  void onSignUp(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.scanEmiratesId);
  }

  void onBack(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.signOption);
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
    passwordCtrl.dispose();
    super.dispose();
  }
}
