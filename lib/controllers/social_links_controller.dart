import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/social_links.dart';
import '../services/user_service.dart';

class SocialLinksController extends ChangeNotifier {
  SocialLinksController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  SocialLinks? links;

  Future<void> init() async {
    await _loadLinks();
  }

  Future<void> _loadLinks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) return;
      links = await _userService.getSocialMediaLinks(userId);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> open(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
