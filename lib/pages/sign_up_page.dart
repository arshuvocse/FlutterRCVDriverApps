import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/sign_up_controller.dart';
import '../widgets/loading_overlay.dart';
import '../models/vehicle_type.dart';

class SignUpPage extends StatefulWidget {
  final String? frontImagePath;
  final String? backImagePath;

  const SignUpPage({
    super.key,
    this.frontImagePath,
    this.backImagePath,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final SignUpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignUpController(
      frontImagePath: widget.frontImagePath,
      backImagePath: widget.backImagePath,
    );
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
      child: Consumer<SignUpController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: LoadingOverlay(
              isLoading: controller.isLoading,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFEE4A7), Color(0xFFFEE4A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _TopBar(onBack: () => controller.onBack(context)),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Center(
                                child: Image.asset(
                                  'assets/images/pickmelogomain.png',
                                  height: 100,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  'Sign Up as Driver',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
                                        offset: Offset(1, 2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Registration Card',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _ImageBox(imagePath: controller.frontImagePath),
                              const SizedBox(height: 12),
                              const Text(
                                'Back Emirates ID',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _ImageBox(imagePath: controller.backImagePath),
                              const SizedBox(height: 12),
                              _TextField(
                                controller: controller.fullNameCtrl,
                                label: 'Full Name *',
                              ),
                              _TextField(
                                controller: controller.trafficPlateCtrl,
                                label: 'Enter Traffic Plate No *',
                              ),
                              _TextField(
                                controller: controller.tcNoCtrl,
                                label: 'Enter T.C NO. *',
                              ),
                              _TextField(
                                controller: controller.companyCtrl,
                                label: 'Company Name *',
                              ),
                              _TextField(
                                controller: controller.nationalityCtrl,
                                label: 'Nationality *',
                              ),
                              _DropdownField<VehicleType>(
                                label: 'Vehicle Type  *',
                                value: controller.selectedVehicle,
                                items: controller.vehicleTypes
                                    .map((v) => DropdownMenuItem<VehicleType>(
                                          value: v,
                                          child: Text(v.name),
                                        ))
                                    .toList(),
                                onChanged: controller.onVehicleChanged,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Mobile No. *',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      controller: controller.countryCodeCtrl,
                                      decoration: const InputDecoration(
                                        hintText: '+971',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: controller.mobileCtrl,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        hintText: 'Eg. 55XXXXXX',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Garage Location *',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 300,
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      initialCameraPosition:
                                          controller.initialCameraPosition,
                                      onMapCreated: controller.onMapCreated,
                                      myLocationButtonEnabled: false,
                                      myLocationEnabled: true,
                                      markers: controller.markers,
                                      onTap: controller.onMapTap,
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      right: 60,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.showSearchSheet(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.search,
                                                  color: Colors.grey),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  controller.locationLabel ??
                                                      'Search location',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black87),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        elevation: 4,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.my_location,
                                            color: Colors.black87,
                                          ),
                                          onPressed:
                                              controller.onCurrentLocation,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _PasswordField(
                                controller: controller.passwordCtrl,
                                label: 'Password *',
                              ),
                              _PasswordField(
                                controller: controller.confirmPasswordCtrl,
                                label: 'Confirm Password *',
                                onChanged: (_) =>
                                    controller.validatePasswords(),
                              ),
                              if (controller.passwordError != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, left: 4),
                                  child: Text(
                                    controller.passwordError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: controller.termsAccepted,
                                    onChanged: controller.onToggleTerms,
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Text('I agree to the '),
                                        GestureDetector(
                                          onTap: controller.openTerms,
                                          child: const Text(
                                            'Terms & Conditions',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _PrimaryButton(
                                isBusy: controller.isSubmitting,
                                text: 'Get Code',
                                onPressed: controller.isSubmitting
                                    ? null
                                    : () => controller.submit(context),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Please enter your mobile number to receive OTP Code',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Have an account? ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.onSignIn(context),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
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

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFFEE4A7),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          iconSize: 35,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String? imagePath;
  const _ImageBox({this.imagePath});

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE4A7),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(1, -10),
            blurRadius: 5,
          ),
        ],
      ),
      child: hasImage
          ? Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
            )
          : Container(color: Colors.grey.shade300),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _TextField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  const _PasswordField({
    required this.controller,
    required this.label,
    this.onChanged,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final Widget? hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  const _DropdownField({
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            value: value,
            hint: hint,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final bool isBusy;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.text,
    required this.isBusy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: isBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
      ),
    );
  }
}
