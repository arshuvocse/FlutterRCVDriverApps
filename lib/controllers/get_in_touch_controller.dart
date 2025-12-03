import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchController extends ChangeNotifier {
  bool isOnline = true;
  bool showBottomSheet = false;

  void switchToOnline() {
    isOnline = true;
    notifyListeners();
  }

  void switchToOffline() {
    isOnline = false;
    notifyListeners();
  }

  void openBottomSheet() {
    showBottomSheet = true;
    notifyListeners();
  }

  void closeBottomSheet() {
    showBottomSheet = false;
    notifyListeners();
  }

  Future<void> launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchAppCall(String scheme) async {
    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchMap(String query) async {
    final uri = Uri.parse('https://www.google.com/maps?q=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
