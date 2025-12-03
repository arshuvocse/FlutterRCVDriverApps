import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sign_option_controller.dart';

class SignOptionPage extends StatefulWidget {
  const SignOptionPage({super.key});

  @override
  State<SignOptionPage> createState() => _SignOptionPageState();
}

class _SignOptionPageState extends State<SignOptionPage> {
  late final SignOptionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignOptionController();
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
      child: Consumer<SignOptionController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8F6FF), Color(0xFFE6EDFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      left: -90,
                      top: -70,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4F1C94).withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -70,
                      top: 100,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF006ADC).withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  iconSize: 28,
                                  onPressed: () => controller.onBackPressed(context),
                                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 22,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/pickmelogomain.png',
                                  height: 140,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Join PickMe Drivers',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.typingText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 8,
                                  children: const [
                                    _Pill(text: 'Fast onboarding'),
                                    _Pill(text: 'Secure data'),
                                    _Pill(text: '24/7 support'),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _PrimaryButton(
                                  text: 'Create Account',
                                  gradient: const [Color(0xFF4F1C94), Color(0xFF006ADC)],
                                  onPressed: () => controller.onSignUp(context),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: _DividerLine()),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: _DividerLine()),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _PrimaryButton(
                                  text: 'Sign In',
                                  gradient: const [Color(0xFF006ADC), Color(0xFF00A7B3)],
                                  onPressed: () => controller.onSignIn(context),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () => controller.onSignIn(context),
                                  child: const Text(
                                    'Already a driver? Log in',
                                    style: TextStyle(
                                      color: Color(0xFF006ADC),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shield, size: 16, color: Color(0xFF4F1C94)),
                              SizedBox(width: 6),
                              Text(
                                'Trusted by thousands of drivers',
                                style: TextStyle(color: Color(0xFF4A4A4A)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final List<Color> gradient;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.text,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}
