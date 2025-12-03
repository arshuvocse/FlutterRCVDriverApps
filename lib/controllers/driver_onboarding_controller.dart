import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/translator.dart';
import '../models/onboarding_step.dart';
import '../routes/app_routes.dart';
import '../services/user_service.dart';

class DriverOnboardingController extends ChangeNotifier {
  DriverOnboardingController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;
  final PageController pageController = PageController();
  final Translator translator = Translator.instance;

  List<OnboardingStep> steps = [];
  bool isLoading = false;
  int currentIndex = 0;
  Timer? _autoSlideTimer;

  Future<void> init(BuildContext context) async {
    await fetchOnboardingSteps();
    _startAutoSlide();
    if (!context.mounted) return;
    await checkForUserPreferences(context);
  }

  Future<void> fetchOnboardingSteps() async {
    isLoading = true;
    notifyListeners();
    try {
      steps = await _userService.getOnboardingStepList();
    } catch (e) {
      debugPrint('Failed to load onboarding steps: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (steps.isEmpty) return;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients || steps.isEmpty) return;
      final next = currentIndex >= steps.length - 1 ? 0 : currentIndex + 1;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      currentIndex = next;
      notifyListeners();
    });
  }

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> startJourney(BuildContext context) async {
    if (!context.mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.givePermission);
  }

  Future<void> checkForUserPreferences(BuildContext context) async {
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

  Future<void> changeLanguage(Locale locale) async {
    translator.setLocale(locale);
    await fetchOnboardingSteps();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
