import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/driver_onboarding_controller.dart';
import '../widgets/app_background.dart';

const _primaryColor = Color(0xFF7C3AED);
const _accentColor = Color(0xFF22D3EE);
const _backgroundColor = Color(0xFF070C1D);

class DriverOnboardingPage extends StatefulWidget {
  const DriverOnboardingPage({super.key});

  @override
  State<DriverOnboardingPage> createState() => _DriverOnboardingPageState();
}

class _DriverOnboardingPageState extends State<DriverOnboardingPage> {
  late final DriverOnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DriverOnboardingController();
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
      child: Consumer<DriverOnboardingController>(
        builder: (context, controller, _) {
          final totalSteps = controller.steps.length;
          final stepLabel =
              totalSteps == 0 ? '0/0' : '${controller.currentIndex + 1}/$totalSteps';
          final progress =
              totalSteps == 0 ? 0.0 : (controller.currentIndex + 1) / totalSteps;
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: GoogleFonts.manropeTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: Scaffold(
              backgroundColor: _backgroundColor,
              body: SafeArea(
                child: Stack(
                  children: [
                    const AppBackground(),
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TopHero(
                            stepLabel: stepLabel,
                            progress: progress,
                            isLoading: controller.isLoading,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: const [
                              _MiniChip(text: 'Live guidance'),
                              _MiniChip(text: 'Secure data'),
                              _MiniChip(text: 'Quick approval'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const _InfoCard(),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 360,
                            width: double.infinity,
                            child: _StepCarousel(
                              controller: controller,
                              stepLabel: stepLabel,
                              progress: progress,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _PrimaryCta(
                            onPressed: () => controller.startJourney(context),
                          ),
                          TextButton(
                            onPressed: controller.isLoading
                                ? null
                                : () => controller.changeLanguage(const Locale('en')),
                            child: Text(
                              'Need help? Contact support',
                              style: GoogleFonts.manrope(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    DriverOnboardingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                  controller.changeLanguage(const Locale('en'));
                },
              ),
              ListTile(
                title: const Text('Arabic'),
                onTap: () {
                  Navigator.pop(context);
                  controller.changeLanguage(const Locale('ar', 'AE'));
                },
              ),
              ListTile(
                title: const Text('Hindi'),
                onTap: () {
                  Navigator.pop(context);
                  controller.changeLanguage(const Locale('hi', 'IN'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopHero extends StatelessWidget {
  final String stepLabel;
  final double progress;
  final bool isLoading;

  const _TopHero({
    required this.stepLabel,
    required this.progress,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111A36), Color(0xFF0C1326)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F1B4B), Color(0xFF1C255D)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car_filled,
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
                      'Driver onboarding',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.72),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A few guided steps to get you earning quickly.',
                      style: GoogleFonts.manrope(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primaryColor, Color(0xFF5B21B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.32),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  'Step $stepLabel',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Welcome, Driver',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay compliant, complete your profile, and unlock trips faster.',
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.14),
              valueColor: const AlwaysStoppedAnimation<Color>(_primaryColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Onboarding progress',
                style: GoogleFonts.manrope(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                isLoading ? 'Loading...' : stepLabel,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  final VoidCallback onPressed;

  const _PrimaryCta({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
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
              blurRadius: 20,
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
          child: Text(
            'Start your journey',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _PageDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 14 : 10,
          height: isActive ? 14 : 10,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [_primaryColor, _accentColor],
                  )
                : null,
            color: isActive ? null : Colors.white.withOpacity(0.35),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
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

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF006ADC)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF182243), Color(0xFF111A32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF10172F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.verified_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Keep your documents ready and follow the guided prompts. We will help you finish quickly.',
              style: GoogleFonts.manrope(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCarousel extends StatelessWidget {
  final DriverOnboardingController controller;
  final String stepLabel;
  final double progress;

  const _StepCarousel({
    required this.controller,
    required this.stepLabel,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1529), Color(0xFF0A1123)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.isLoading ? 'Loading steps...' : 'Your onboarding path',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Text(
                  'Step $stepLabel',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                _primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: _primaryColor,
                    ),
                  )
                : PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.updateIndex,
                    itemCount: controller.steps.length,
                    itemBuilder: (context, index) {
                      final step = controller.steps[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFF9FAFB),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [_primaryColor, _accentColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    step.title,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: _primaryColor.withOpacity(0.7),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 4,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [_primaryColor, _accentColor],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                step.description,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: const Color(0xFF334155),
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          _PageDots(
            count: controller.steps.length,
            activeIndex: controller.currentIndex,
          ),
        ],
      ),
    );
  }
}
