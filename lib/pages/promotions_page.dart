import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/promotions_controller.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  late final PromotionsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PromotionsController();
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
      child: Consumer<PromotionsController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFEE4A7), Color(0xFFFEE4A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFEE4A7), Color(0xFFFEE4A7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _PrimaryButton(
                          text: 'Change Language',
                          onPressed: () => _showSnack(context, 'Coming soon'),
                          hidden: true,
                        ),
                        const SizedBox(height: 12),
                        _PrimaryButton(
                          text: 'Change Password',
                          onPressed: () => _showPasswordSheet(context, controller),
                          hidden: true,
                        ),
                        const SizedBox(height: 12),
                        _PrimaryButton(
                          text: 'Change Location',
                          onPressed: () => controller.goToLocation(context),
                        ),
                        const SizedBox(height: 12),
                        _PrimaryButton(
                          text: 'Change Bank Info',
                          onPressed: () => controller.goToBank(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPasswordSheet(
    BuildContext context,
    PromotionsController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Password *'),
                const SizedBox(height: 6),
                _PasswordField(
                  controller: controller.passwordCtrl,
                  obscure: !controller.isPasswordVisible,
                  onToggle: controller.togglePasswordVisibility,
                ),
                const SizedBox(height: 12),
                const Text('Confirm Password *'),
                const SizedBox(height: 6),
                _PasswordField(
                  controller: controller.confirmCtrl,
                  obscure: !controller.isConfirmVisible,
                  onToggle: controller.toggleConfirmVisibility,
                  onChanged: (_) {
                    controller.validatePasswords();
                  },
                ),
                if (controller.validatePasswords() == 'Passwords do not match')
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Passwords do not match',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 100,
                        child: Center(child: Text('Cancel')),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isUpdatingPassword
                          ? null
                          : () async {
                              final ok = await controller.updatePassword();
                              if (!context.mounted) return;
                              if (ok) {
                                _showSnack(context, 'Updated successfully');
                                Navigator.pop(context);
                              } else {
                                final err = controller.validatePasswords();
                                _showSnack(
                                  context,
                                  err ?? 'Something went wrong',
                                );
                              }
                            },
                      child: controller.isUpdatingPassword
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(
                              width: 100,
                              child: Center(child: Text('Update')),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool hidden;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    this.hidden = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox.shrink();
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F1C94),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
