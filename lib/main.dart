import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'helpers/translator.dart';
import 'pages/driver_onboarding_page.dart';
import 'pages/get_started_page.dart';
import 'pages/login_page.dart';
import 'pages/notifications_page.dart';
import 'pages/terms_conditions_page.dart';
import 'pages/social_links_page.dart';
import 'pages/promotions_page.dart';
import 'pages/scan_emirates_id_page.dart';
import 'pages/sign_option_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/splash_page.dart';
import 'routes/app_routes.dart';
import 'pages/choose_location_page.dart';
import 'pages/update_driver_bank_info_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/calling_page.dart';
import 'pages/my_account_page.dart';
import 'pages/home_page.dart';
import 'pages/otp_page.dart';
import 'pages/give_permission_page.dart';
import 'pages/select_language_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Translator.instance,
      child: Consumer<Translator>(
        builder: (context, translator, _) {
          return MaterialApp(
            title: 'Pick Me Driver App',
            debugShowCheckedModeBanner: false,
            locale: translator.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('hi'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F1C94)),
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => const SplashPage(),
              AppRoutes.getStarted: (_) => const GetStartedPage(),
              AppRoutes.signOption: (_) => const SignOptionPage(),
              AppRoutes.driverOnboarding: (_) => const DriverOnboardingPage(),
              AppRoutes.login: (_) => const LoginPage(),
              AppRoutes.scanEmiratesId: (_) => const ScanEmiratesIdPage(),
              AppRoutes.signUp: (ctx) {
                final args =
                    ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>? ?? {};
                return SignUpPage(
                  frontImagePath: (args['frontImagePath'] ?? '') as String,
                  backImagePath: (args['backImagePath'] ?? '') as String,
                );
              },
              AppRoutes.notifications: (_) => const NotificationsPage(),
              AppRoutes.termsConditions: (_) => const TermsConditionsPage(),
              AppRoutes.socialLinks: (_) => const SocialLinksPage(),
              AppRoutes.promotions: (_) => const PromotionsPage(),
              AppRoutes.chooseLocation: (_) => const ChooseLocationPage(),
              AppRoutes.updateBank: (_) => const UpdateDriverBankInfoPage(),
              AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
              AppRoutes.calling: (_) => const CallingPage(),
              AppRoutes.home: (_) => const HomePage(),
              AppRoutes.otp: (_) => const OtpPage(),
              AppRoutes.myAccount: (_) => const MyAccountPage(),
              AppRoutes.givePermission: (_) => const GivePermissionPage(),
              AppRoutes.selectLanguage: (_) => const SelectLanguagePage(),
            },
          );
        },
      ),
    );
  }
}
