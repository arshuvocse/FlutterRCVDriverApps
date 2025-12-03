import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/app_routes.dart';

class ScanEmiratesIdController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  String? frontImagePath;
  String? backImagePath;
  bool isScanning = false;

  void init() {}

  Future<void> pickImage({
    required bool isFront,
    required bool fromCamera,
  }) async {
    try {
      final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        if (isFront) {
          frontImagePath = file.path;
        } else {
          backImagePath = file.path;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('pickImage error: $e');
    }
  }

  Future<void> onScan(BuildContext context) async {
    if (isScanning) return;
    if (frontImagePath == null || backImagePath == null) {
      _showAlert(context, 'Error', 'Please capture both images before proceeding.');
      return;
    }

    isScanning = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 5));
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(
        AppRoutes.signUp,
        arguments: {
          'frontImagePath': frontImagePath,
          'backImagePath': backImagePath,
        },
      );
    } catch (e) {
      _showAlert(context, 'Error', 'An unexpected error occurred: $e');
    } finally {
      isScanning = false;
      notifyListeners();
    }
  }

  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
