import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../controllers/my_account_controller.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late final MyAccountController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyAccountController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init();
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
      child: Consumer<MyAccountController>(
        builder: (context, controller, _) {
          final profile = controller.profile;
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFEE4A7), Color(0xFFFEE4A7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: controller.loadProfile,
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                      'assets/images/userlogoicon.svg',
                                      width: 80,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    profile?.mobileNumber ?? '',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '💰 Your Wallet Balance:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            decoration: TextDecoration.underline,
                                            color: Color(0xFF1565C0),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: Text(
                                            profile?.driverBalance ?? '0',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controller.withdrawCtrl,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: 'Enter Amount to Withdraw',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF4F1C94),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: controller.isWithdrawing
                                                ? null
                                                : () => controller.withdraw(context),
                                            child: controller.isWithdrawing
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Withdraw',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _InfoCard(
                                  title: 'Driver Information',
                                  children: [
                                    _infoItem('🔹 Driver Code', profile?.driverUserCode),
                                    _infoItem('👤 Full Name', profile?.fullName),
                                    _infoItem('🚘 Traffic Plate No:', profile?.trafficPlateNo),
                                    _infoItem('📌 TC No:', profile?.tcNo),
                                    _infoItem('🏢 Company Name:', profile?.companyName),
                                    _infoItem('🌍 Nationality:', profile?.nationality),
                                    _linkItem(
                                      '📍 Address:',
                                      profile?.addressName,
                                      controller.openAddressOnMap,
                                    ),
                                    _infoItem('🏦 Bank Name', profile?.bankName),
                                    _infoItem('🔢 Account Number', profile?.accountNumber),
                                    _infoItem('💳 IBAN', profile?.iban),
                                    _infoItem('⚡ Swift Code', profile?.swiftCode),
                                    _infoItem('📍 Branch Name', profile?.branchName),
                                    _infoItem('💰 Last Withdraw', profile?.lastWithdrawAmount),
                                    _infoItem('🗓️ Last Withdraw Date', profile?.lastWithdrawDate),
                                    _infoItem('📄 Withdraw Status', profile?.withdrawStatus),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
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

  Widget _infoItem(String label, String? value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkItem(String label, String? value, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          value ?? 'N/A',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFAFAFA),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
