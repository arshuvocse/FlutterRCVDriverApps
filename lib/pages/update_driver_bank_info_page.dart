import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/update_bank_controller.dart';

class UpdateDriverBankInfoPage extends StatefulWidget {
  const UpdateDriverBankInfoPage({super.key});

  @override
  State<UpdateDriverBankInfoPage> createState() =>
      _UpdateDriverBankInfoPageState();
}

class _UpdateDriverBankInfoPageState extends State<UpdateDriverBankInfoPage> {
  late final UpdateBankController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UpdateBankController();
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
      child: Consumer<UpdateBankController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('🏦 Bank Information'),
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _Field(
                    icon: '🏢',
                    label: 'Bank Name',
                    controller: controller.bankNameCtrl,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    icon: '💳',
                    label: 'Account Number',
                    controller: controller.accountNumberCtrl,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    icon: '🧾',
                    label: 'IBAN',
                    controller: controller.ibanCtrl,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    icon: '🔁',
                    label: 'Swift Code',
                    controller: controller.swiftCtrl,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    icon: '🏬',
                    label: 'Branch Name',
                    controller: controller.branchCtrl,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(140, 50),
                        ),
                        onPressed: controller.isSaving
                            ? null
                            : () async {
                                final ok = await controller.submit();
                                if (!context.mounted) return;
                                if (ok) {
                                  _showSnack(context, 'Updated successfully');
                                  Navigator.pop(context, true);
                                } else {
                                  _showSnack(
                                    context,
                                    'Please fill all fields correctly',
                                  );
                                }
                              },
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
                                'Update',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(140, 50),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Field extends StatelessWidget {
  final String icon;
  final String label;
  final TextEditingController controller;

  const _Field({
    required this.icon,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
