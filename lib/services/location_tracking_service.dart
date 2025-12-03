import 'dart:async';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/driver_live_tracking_request.dart';
import '../services/user_service.dart';

class LocationTrackingService {
  LocationTrackingService({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;
  StreamSubscription<Position>? _sub;

  Future<void> startTracking({
    required int tripId,
    required String acceptedTripStatus,
    int? customerUserId,
  }) async {
    await _ensurePermission();
    final prefs = await SharedPreferences.getInstance();
    final driverUserId = prefs.getInt('UserId') ?? 0;
    if (driverUserId == 0) return;

    _sub?.cancel();
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
      ),
    ).listen((pos) async {
      final address = await _reverseGeocode(pos.latitude, pos.longitude);
      final req = DriverLiveTrackingRequest(
        tripId: tripId,
        driverUserId: driverUserId,
        acceptedTripStatus: acceptedTripStatus,
        userAddress: '',
        userLatitude: '',
        userLongitude: '',
        driverAddress: address ?? '',
        driverLatitude: pos.latitude.toString(),
        driverLongitude: pos.longitude.toString(),
        customerUserId: customerUserId,
      );
      try {
        await _userService.saveDriverLiveTracking(req);
      } catch (_) {
        // swallow errors to keep stream alive
      }
    });
  }

  Future<void> stopTracking() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _ensurePermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
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
}
