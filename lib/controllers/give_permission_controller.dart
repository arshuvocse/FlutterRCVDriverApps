import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class GivePermissionController extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 0.94);
  int currentIndex = 0;
  Timer? _autoTimer;
  bool isRequesting = false;

  final List<OnboardingItem> items = [
    const OnboardingItem(
      title: '📍 Location Permission',
      subtitle: 'Share your location so we can show nearby job requests.',
      image: 'assets/images/mobilepermission.svg',
    ),
    const OnboardingItem(
      title: '🚶 Foreground Location Access',
      subtitle: 'When the app is open, we use your live location for nearby jobs.',
      image: 'assets/images/mobilepermission.svg',
    ),
    const OnboardingItem(
      title: '🛰️ Background Location Access',
      subtitle: 'In the background, we alert you when a close job appears.',
      image: 'assets/images/mobilepermission.svg',
    ),
    const OnboardingItem(
      title: '⚙️ Foreground Service',
      subtitle: 'A foreground service keeps tracking active with a visible notice.',
      image: 'assets/images/mobilepermission.svg',
    ),
    const OnboardingItem(
      title: '🔔 Notification Access',
      subtitle: 'Allow alerts so you never miss new jobs or updates.',
      image: 'assets/images/mobilepermission.svg',
    ),
  ];

  Future<void> init(BuildContext context) async {
    _startAutoSlide();
    if (!context.mounted) return;
    await _checkExistingSession(context);
  }

  Future<void> _checkExistingSession(BuildContext context) async {
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

  void _startAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients) return;
      final next = currentIndex >= items.length - 1 ? 0 : currentIndex + 1;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentIndex = next;
      notifyListeners();
    });
  }

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> requestPermissions(BuildContext context) async {
    if (isRequesting) return;
    isRequesting = true;
    notifyListeners();
    try {
      // Location when in use
      final locWhenInUse = await Permission.locationWhenInUse.request();
      if (!locWhenInUse.isGranted) {
        if (!context.mounted) return;
        final openSettings = await _promptOpenSettings(
          context,
          title: 'Location required',
          message: 'Please enable location access to show nearby jobs.',
        );
        if (openSettings) {
          await openAppSettings();
        }
        return;
      }

      // Background location (ask politely)
      await Permission.locationAlways.request();

      // Notifications (Android 13+)
      if (Platform.isAndroid) {
        await Permission.notification.request();
      }

      // Ensure GPS is on
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!context.mounted) return;
        final openGps = await _promptOpenSettings(
          context,
          title: 'Turn on GPS',
          message: 'GPS needs to stay on for accurate job alerts.',
          confirmLabel: 'Open settings',
        );
        if (openGps) {
          await Geolocator.openLocationSettings();
        }
        return;
      }

      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.signOption,
        (_) => false,
      );
    } finally {
      isRequesting = false;
      notifyListeners();
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _promptOpenSettings(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Open settings',
    String cancelLabel = 'Cancel',
  }) async {
    if (!context.mounted) return false;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(cancelLabel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(confirmLabel),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
