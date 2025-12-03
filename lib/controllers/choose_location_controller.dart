import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_service.dart';

class ChooseLocationController extends ChangeNotifier {
  ChooseLocationController({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;

  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  String? selectedAddress;
  bool isLoading = false;

  TextEditingController searchCtrl = TextEditingController();
  TextEditingController searchSheetCtrl = TextEditingController();
  List<PlacePrediction> predictions = [];

  Future<void> init() async {
    await _ensurePermission();
    await _initLocation();
  }

  Future<void> _ensurePermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
  }

  Future<void> _initLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await _setPosition(LatLng(pos.latitude, pos.longitude));
      mapController?.moveCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 14),
      );
    } catch (_) {}
  }

  Future<void> _setPosition(LatLng latLng) async {
    selectedLatLng = latLng;
    selectedAddress = await _reverseGeocode(latLng.latitude, latLng.longitude);
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapTap(LatLng latLng) {
    _setPosition(latLng);
    mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> useCurrentLocation() async {
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

  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('GooglePlacesApiKey') ?? '';
      if (apiKey.isEmpty) {
        final placemarks = await geo.placemarkFromCoordinates(lat, lng);
        final p = placemarks.first;
        return [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country
        ].where((e) => (e ?? '').isNotEmpty).join(', ');
      }
      final uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final results = data['results'] as List<dynamic>;
      if (results.isEmpty) return null;
      return results.first['formatted_address']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> searchPlaces(String query) async {
    predictions = [];
    notifyListeners();
    if (query.trim().isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('GooglePlacesApiKey') ?? '';
      if (apiKey.isEmpty) return;
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&types=address';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return;
      final data = jsonDecode(res.body);
      final preds = data['predictions'] as List<dynamic>;
      predictions = preds
          .map((e) => PlacePrediction(
                description: e['description'],
                placeId: e['place_id'],
              ))
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> choosePrediction(PlacePrediction prediction) async {
    searchCtrl.text = prediction.description;
    searchSheetCtrl.text = prediction.description;
    predictions = [];
    notifyListeners();
    final coords = await _placeIdToLatLng(prediction.placeId);
    if (coords != null) {
      await _setPosition(coords);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(coords, 14));
    }
  }

  Future<LatLng?> _placeIdToLatLng(String placeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('GooglePlacesApiKey') ?? '';
      if (apiKey.isEmpty) return null;
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final loc = data['result']?['geometry']?['location'];
      if (loc == null) return null;
      return LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateLocation(BuildContext context) async {
    final latLng = selectedLatLng;
    if (latLng == null || (latLng.latitude == 0 && latLng.longitude == 0)) {
      return false;
    }
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('UserId') ?? 0;
      if (userId == 0) return false;
      // Reuse UpdateDriverInformation with ChangeType=LatLongValue
      final body = {
        'DriverUserID': userId,
        'LatValue': latLng.latitude.toString(),
        'LongValue': latLng.longitude.toString(),
        'AddressName': selectedAddress ?? '',
        'ChangeType': 'LatLongValue',
      };
      final res = await _userService.updateDriverInformationRaw(body);
      if (res) {
        return true;
      }
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}

class PlacePrediction {
  final String description;
  final String placeId;
  PlacePrediction({required this.description, required this.placeId});
}
