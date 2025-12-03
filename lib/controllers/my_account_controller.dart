import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/driver_user.dart';
import '../models/withdraw_request.dart';
import '../services/user_service.dart';

class MyAccountController extends ChangeNotifier {
  MyAccountController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  DriverUser? profile;
  bool isLoading = false;
  bool isWithdrawing = false;

  final TextEditingController withdrawCtrl = TextEditingController();

  Future<void> init() async {
    await loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) {
        isLoading = false;
        notifyListeners();
        return;
      }
      profile = await _userService.getDriverUserById(userId);
    } catch (_) {
      profile = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> withdraw(BuildContext context) async {
    if (isWithdrawing) return;
    final amountText = withdrawCtrl.text.trim();
    if (amountText.isEmpty) {
      _showSnack(context, 'Enter an amount');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showSnack(context, 'Enter a valid amount');
      return;
    }
    final wallet = double.tryParse(profile?.driverBalance ?? '0') ?? 0;
    if (amount > wallet) {
      _showSnack(context, 'Withdraw amount cannot exceed wallet balance');
      withdrawCtrl.text = wallet.toStringAsFixed(2);
      return;
    }

    isWithdrawing = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      final req = WithdrawRequest(amount: amount, driverUserId: userId);
      final res = await _userService.saveWithdraw(req);
      if (!context.mounted) return;
      if (res.isSuccess) {
        _showSnack(context, 'Successfully done');
        withdrawCtrl.clear();
        await loadProfile();
      } else {
        _showSnack(context, res.errorMessageNew);
      }
    } catch (_) {
      if (!context.mounted) return;
      _showSnack(context, 'Something went wrong');
    } finally {
      isWithdrawing = false;
      notifyListeners();
    }
  }

  Future<void> openAddressOnMap() async {
    final lat = profile?.latValue;
    final lon = profile?.longValue;
    if (lat == null || lon == null || lat.isEmpty || lon.isEmpty) return;
    final url = Uri.parse('https://www.google.com/maps?q=$lat,$lon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    withdrawCtrl.dispose();
    super.dispose();
  }
}
