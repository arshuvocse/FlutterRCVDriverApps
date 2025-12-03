import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_item.dart';
import '../services/user_service.dart';

class NotificationsController extends ChangeNotifier {
  NotificationsController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  List<NotificationItem> notifications = [];
  bool isLoading = false;

  Future<void> init() async {
    await loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) {
        notifications = [];
      } else {
        notifications = await _userService.getDriverNotificationList(userId);
      }
    } catch (_) {
      notifications = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
