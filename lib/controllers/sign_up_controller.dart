import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/register_user_request.dart';
import '../models/vehicle_type.dart';
import '../routes/app_routes.dart';
import '../services/user_service.dart';

class SignUpController extends ChangeNotifier {
  SignUpController({
    this.frontImagePath,
    this.backImagePath,
    UserService? userService,
  }) : _userService = userService ?? UserService();

  final UserService _userService;

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController trafficPlateCtrl = TextEditingController();
  final TextEditingController tcNoCtrl = TextEditingController();
  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController nationalityCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController countryCodeCtrl =
      TextEditingController(text: '+971');
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  List<VehicleType> vehicleTypes = [];
  VehicleType? selectedVehicle;

  String? locationLabel;
  String? latValue;
  String? longValue;

  bool termsAccepted = false;
  bool isSubmitting = false;
  bool isLoading = false;
  String? passwordError;

  final String? frontImagePath;
  final String? backImagePath;

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(25.2048, 55.2708), zoom: 12);

  Future<void> init(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    await _loadVehicleTypes();
    await _initLocation();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadVehicleTypes() async {
    try {
      vehicleTypes = await _userService.getVehicleTypeList();
    } catch (_) {}
  }

  Future<void> _initLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      await _setPosition(latLng);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    } catch (_) {}
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapTap(LatLng latLng) {
    _setPosition(latLng);
    mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> onCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      await _setPosition(latLng);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    } catch (_) {}
  }

  Future<void> _setPosition(LatLng latLng) async {
    latValue = latLng.latitude.toString();
    longValue = latLng.longitude.toString();
    locationLabel = await _reverseGeocode(latLng.latitude, latLng.longitude);
    markers = {
      Marker(
        markerId: const MarkerId('selected'),
        position: latLng,
        infoWindow: InfoWindow(title: locationLabel ?? 'Selected'),
      ),
    };
    notifyListeners();
  }

  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lng);
      final p = placemarks.first;
      return [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.country
      ].where((e) => (e ?? '').isNotEmpty).join(', ');
    } catch (_) {
      return null;
    }
  }

  void showSearchSheet(BuildContext context) {
    // Placeholder: implement Places autocomplete if needed.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search not implemented')),
    );
  }

  void onVehicleChanged(VehicleType? value) {
    selectedVehicle = value;
    notifyListeners();
  }

  void validatePasswords() {
    if (passwordCtrl.text.isNotEmpty &&
        confirmPasswordCtrl.text.isNotEmpty &&
        passwordCtrl.text != confirmPasswordCtrl.text) {
      passwordError = 'Passwords do not match.';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  void onToggleTerms(bool? v) {
    termsAccepted = v ?? false;
    notifyListeners();
  }

  void openTerms() async {
    const url = 'https://sites.google.com/view/termsconditionpickme/home';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> submit(BuildContext context) async {
    if (isSubmitting) return;
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      final req = RegisterUserRequest(
        vehicletypeId: selectedVehicle?.name ?? '',
        fullName: fullNameCtrl.text.trim(),
        trafficPlateNo: trafficPlateCtrl.text.trim(),
        tcNo: tcNoCtrl.text.trim(),
        companyName: companyCtrl.text.trim(),
        nationality: nationalityCtrl.text.trim(),
        mobileNumber:
            '${countryCodeCtrl.text.trim()}${mobileCtrl.text.trim()}',
        password: passwordCtrl.text.trim(),
        imageBase64String: await _encodeFile(backImagePath ?? ''),
        driverFrontImageBase64String: await _encodeFile(frontImagePath ?? ''),
        driverImageInfo: '',
        latValue: latValue ?? '',
        longValue: longValue ?? '',
        addressName: locationLabel ?? '',
        termsAccepted: termsAccepted,
      );

      final res = await _userService.registerUser(req);
      if (!context.mounted) return;
      if (res.isSuccess) {
        Navigator.of(context).pushNamed(
          AppRoutes.otp,
          arguments: {'mobile': req.mobileNumber},
        );
      } else {
        _showSnack(context, res.errorMessageNew);
      }
    } catch (_) {
      if (!context.mounted) return;
      _showSnack(context, 'Something went wrong');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  bool _validateInputs() {
    if ((frontImagePath ?? '').isEmpty || (backImagePath ?? '').isEmpty) {
      return false;
    }
    if (fullNameCtrl.text.trim().isEmpty) return false;
    if (trafficPlateCtrl.text.trim().isEmpty) return false;
    if (tcNoCtrl.text.trim().isEmpty) return false;
    if (mobileCtrl.text.trim().isEmpty) return false;
    if (latValue == null || longValue == null) return false;
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      passwordError = 'Passwords do not match.';
      return false;
    }
    if (selectedVehicle == null) return false;
    if (!termsAccepted) return false;
    passwordError = null;
    return true;
  }

  Future<String> _encodeFile(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onSignIn(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    mapController?.dispose();
    fullNameCtrl.dispose();
    trafficPlateCtrl.dispose();
    tcNoCtrl.dispose();
    companyCtrl.dispose();
    nationalityCtrl.dispose();
    mobileCtrl.dispose();
    countryCodeCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }
}
