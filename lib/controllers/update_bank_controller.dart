import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_service.dart';

class UpdateBankController extends ChangeNotifier {
  UpdateBankController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController ibanCtrl = TextEditingController();
  final TextEditingController swiftCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();

  bool isSaving = false;

  Future<bool> submit() async {
    if (isSaving) return false;
    if (bankNameCtrl.text.trim().isEmpty ||
        accountNumberCtrl.text.trim().isEmpty ||
        ibanCtrl.text.trim().isEmpty ||
        swiftCtrl.text.trim().isEmpty ||
        branchCtrl.text.trim().isEmpty) {
      return false;
    }
    isSaving = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) return false;
      final body = {
        'DriverUserID': userId,
        'BankName': bankNameCtrl.text.trim(),
        'AccountNumber': accountNumberCtrl.text.trim(),
        'IBAN': ibanCtrl.text.trim(),
        'SwiftCode': swiftCtrl.text.trim(),
        'BranchName': branchCtrl.text.trim(),
        'ChangeType': 'BankInfo',
      };
      final ok = await _userService.updateDriverInformationRaw(body);
      return ok;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    accountNumberCtrl.dispose();
    ibanCtrl.dispose();
    swiftCtrl.dispose();
    branchCtrl.dispose();
    super.dispose();
  }
}
