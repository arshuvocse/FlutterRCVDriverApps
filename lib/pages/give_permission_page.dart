import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/give_permission_controller.dart';
import '../widgets/app_background.dart';

const _primaryColor = Color(0xFF7C3AED);
const _accentColor = Color(0xFF22D3EE);
const _backgroundColor = Color(0xFF0E1117);

class GivePermissionPage extends StatefulWidget {
  const GivePermissionPage({super.key});

  @override
  State<GivePermissionPage> createState() => _GivePermissionPageState();
}

class _GivePermissionPageState extends State<GivePermissionPage> {
  late final GivePermissionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GivePermissionController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GivePermissionController>(
        builder: (context, controller, _) {
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: GoogleFonts.manropeTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double screenHeight = constraints.maxHeight;
                final double cardHeight =
                    math.min(math.max(screenHeight * 0.55, 380.0), 520.0);
                return Scaffold(
                  backgroundColor: _backgroundColor,
                  body: Stack(
                    children: [
                      const AppBackground(),
                      SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Header(),
                              const SizedBox(height: 14),
                              const _PrivacyBanner(),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: cardHeight,
                                child: PageView.builder(
                                  controller: controller.pageController,
                                  onPageChanged: controller.onPageChanged,
                                  itemCount: controller.items.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.items[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 2),
                                      child: _PermissionCard(item: item),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),
                              _ProgressDots(
                                count: controller.items.length,
                                activeIndex: controller.currentIndex,
                              ),
                              const SizedBox(height: 18),
                              _PrimaryCta(
                                isLoading: controller.isRequesting,
                                onPressed: controller.isRequesting
                                    ? null
                                    : () => controller.requestPermissions(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF121B34), Color(0xFF0D1528)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_primaryColor, _accentColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.32),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Permissions to keep you online',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Allow access so we can send nearby jobs, alerts, and keep your status accurate.',
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.32),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
              ),
            ),
            child: const Icon(Icons.lock_outline, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'We never share your data. Permissions keep your trips accurate and alerts instant.',
              style: GoogleFonts.manrope(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryCta({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [_primaryColor, Color(0xFF5B21B6), _accentColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Enable & Continue',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.1,
                  ),
                ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final OnboardingItem item;

  const _PermissionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1529), Color(0xFF0B1123)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Text(
              item.title,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                item.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withOpacity(0.88),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Chip(label: 'Secure'),
              SizedBox(width: 8),
              _Chip(label: 'Fast setup'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _ProgressDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 12,
          width: isActive ? 26 : 12,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [_primaryColor, _accentColor],
                  )
                : null,
            color: isActive ? null : Colors.white.withOpacity(0.28),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
