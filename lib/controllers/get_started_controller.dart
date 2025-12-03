import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_item.dart';
import '../routes/app_routes.dart';

class GetStartedController extends ChangeNotifier {
  GetStartedController() {
    items = [
      const OnboardingItem(
        title: 'All Services, One App',
        subtitle: 'Explore every service you need — all in one place.',
        image: 'citydesign.png',
      ),
      const OnboardingItem(
        title: 'Arrive Right On Time',
        subtitle: 'Fast and reliable — we get you there safely.',
        image: 'citydesign.png',
      ),
      const OnboardingItem(
        title: 'Seamless Payments',
        subtitle: 'Pay with cash, card, or wallet — your choice.',
        image: 'citydesign.png',
      ),
      const OnboardingItem(
        title: 'Real-Time Tracking',
        subtitle: 'Track your service live and stay updated.',
        image: 'citydesign.png',
      ),
    ];
  }

  late final List<OnboardingItem> items;
  final PageController pageController = PageController();
  int currentIndex = 0;
  Timer? _autoSlideTimer;
  bool _disposed = false;

  Future<void> init(BuildContext context) async {
    _startAutoSlide();
    await _checkForUserPreferences(context);
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_disposed || !pageController.hasClients) return;
      if (currentIndex < items.length - 1) {
        final next = currentIndex + 1;
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        currentIndex = next;
        notifyListeners();
      } else {
        _autoSlideTimer?.cancel();
      }
    });
  }

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> onGetStarted(BuildContext context) async {
    if (!context.mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.signOption);
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

  @override
  void dispose() {
    _disposed = true;
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
