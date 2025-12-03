import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/select_language_controller.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  late final SelectLanguageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SelectLanguageController();
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
      child: Consumer<SelectLanguageController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/pickmelogomain.png',
                        height: 160,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _LangOption(
                        title: 'English',
                        value: 'en-US',
                        groupValue: controller.selected,
                        onChanged: controller.choose,
                      ),
                      const SizedBox(height: 10),
                      _LangOption(
                        title: 'العربية',
                        value: 'ar-SY',
                        groupValue: controller.selected,
                        onChanged: controller.choose,
                        isRtl: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEE2E24),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: controller.isSaving
                              ? null
                              : () => controller.confirm(context),
                          child: controller.isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Next',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'You can change language later from settings',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/citydesign.png',
                        fit: BoxFit.cover,
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

class _LangOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final bool isRtl;

  const _LangOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        title: Text(
          title,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
