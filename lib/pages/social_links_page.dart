import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/social_links_controller.dart';

class SocialLinksPage extends StatefulWidget {
  const SocialLinksPage({super.key});

  @override
  State<SocialLinksPage> createState() => _SocialLinksPageState();
}

class _SocialLinksPageState extends State<SocialLinksPage> {
  late final SocialLinksController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SocialLinksController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.init());
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
      child: Consumer<SocialLinksController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Follow Us'),
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _SocialButton(
                        text: 'Facebook',
                        color: const Color(0xFF3b5998),
                        onTap: () => controller.open(controller.links?.facebook),
                      ),
                      const SizedBox(height: 15),
                      _SocialButton(
                        text: 'Instagram',
                        color: const Color(0xFFE4405F),
                        onTap: () => controller.open(controller.links?.instagram),
                      ),
                      const SizedBox(height: 15),
                      _SocialButton(
                        text: 'Twitter',
                        color: const Color(0xFF1DA1F2),
                        onTap: () => controller.open(controller.links?.twitter),
                      ),
                      const SizedBox(height: 15),
                      _SocialButton(
                        text: 'LinkedIn',
                        color: const Color(0xFF0077B5),
                        onTap: () => controller.open(controller.links?.linkedIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
