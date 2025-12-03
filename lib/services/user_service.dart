import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/all_credentials.dart';
import '../models/onboarding_step.dart';
import '../models/register_user_request.dart';
import '../models/response_dao.dart';
import '../models/sign_in_request.dart';
import '../models/withdraw_request.dart';
import '../models/trip_banner.dart';
import '../models/trip_summary.dart';
import '../models/vehicle_type.dart';
import '../models/verify_otp_request.dart';
import 'api_service.dart';
import '../models/device_info_request.dart';
import '../models/driver_status.dart';
import '../models/driver_shift_update.dart';
import '../models/driver_user.dart';
import '../models/notification_item.dart';
import '../models/term_condition.dart';
import '../models/update_driver_user_request.dart';
import '../models/social_links.dart';
import '../models/driver_live_tracking_request.dart';

class UserService {
  UserService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<OnboardingStep>> getOnboardingStepList() async {
    final raw = await _apiService.get('UserSetup/GetOnboardingStepList');
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded
          .map((e) => OnboardingStep.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ResponseDao> registerUser(RegisterUserRequest request) async {
    final json = await _apiService.postJson(
      'UserSetup/RegisterUser',
      request.toJson(),
    );
    return ResponseDao.fromJson(json);
  }

  Future<ResponseDao> sendOtpMessage(VerifyOtpRequest request) async {
    final json =
        await _apiService.postJson('UserSetup/SendOTPMessage', request.toJson());
    return ResponseDao.fromJson(json);
  }

  Future<ResponseDao> signIn(SignInRequest request) async {
    final json =
        await _apiService.postJson('UserSetup/SignInInfo', request.toJson());
    return ResponseDao.fromJson(json);
  }

  Future<ResponseDao> saveDriverDeviceInfo(DeviceInfoRequest request) async {
    final json = await _apiService.postJson(
      'UserSetup/SaveDriverUserDeviceInfo',
      request.toJson(),
    );
    return ResponseDao.fromJson(json);
  }

  Future<List<VehicleType>> getVehicleTypeList() async {
    final raw = await _apiService.get('JobsSetup/GetVehicleTypeList');
    final data = jsonDecode(raw);
    if (data is List) {
      return data
          .map((e) => VehicleType.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<AllCredentials> getAllCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('UserId') ?? 0;
    final raw = await _apiService.get(
      'UserSetup/GetAllCredentials?UserInfoId=$userId',
    );
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return AllCredentials.fromJson(data);
  }

  Future<String> getCountryNameFromAPI(String countryCode) async {
    final res =
        await http.get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));
    if (res.statusCode != 200) return 'Unknown Country';
    final parsed = jsonDecode(res.body) as List<dynamic>;
    final name = parsed.first['name']?['common'];
    return name?.toString() ?? 'Unknown Country';
  }

  Future<List<TripBanner>> getBannerList() async {
    final raw = await _apiService.get('UserSetup/GetBannerList');
    final data = jsonDecode(raw);
    if (data is List) {
      return data
          .map((e) => TripBanner.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<TripSummary?> getOngoingTrip(int userId) async {
    final raw = await _apiService.get('Trip/GetDriverOngoingTrip?UserInfoId=$userId');
    if (raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return TripSummary.fromJson(data);
  }

  Future<TripSummary?> getOngoingTripByTripId(int tripId) async {
    final raw = await _apiService.get('Trip/GetDriverOngoingTripByTripId?TripId=$tripId');
    if (raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return TripSummary.fromJson(data);
  }

  Future<DriverStatus?> getDriverShiftStatus(int userId) async {
    final raw = await _apiService.get(
      'Trip/GetDriverShiftforDashBoard?UserInfoId=$userId',
    );
    if (raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return DriverStatus.fromJson(data);
  }

  Future<ResponseDao> updateDriverShiftInfo(DriverShiftUpdate update) async {
    final json =
        await _apiService.postJson('Trip/DriverShiftInfoUpdate', update.toJson());
    return ResponseDao.fromJson(json);
  }

  Future<DriverUser?> getDriverUserById(int userId) async {
    final raw = await _apiService.get(
      'UserSetup/GetDriverUserById?DriverUserID=$userId',
    );
    if (raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return DriverUser.fromJson(data);
  }

  Future<ResponseDao> saveWithdraw(WithdrawRequest request) async {
    final json =
        await _apiService.postJson('UserSetup/SaveWithdraw', request.toJson());
    return ResponseDao.fromJson(json);
  }

  Future<List<NotificationItem>> getDriverNotificationList(int userId) async {
    final raw = await _apiService.get(
      'UserSetup/GetDriverNotificationList?DriverUserID=$userId',
    );
    final data = jsonDecode(raw);
    if (data is List) {
      return data
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<TermCondition>> getDriverTermsConditionList(int userId) async {
    final raw = await _apiService.get(
      'UserSetup/GetDriverTermsConditionList?DriverUserID=$userId',
    );
    final data = jsonDecode(raw);
    if (data is List) {
      return data
          .map((e) => TermCondition.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ResponseDao> updateDriverUser(UpdateDriverUserRequest request) async {
    final json = await _apiService.postJson(
      'UserSetup/UpdateDriverUser',
      request.toJson(),
    );
    return ResponseDao.fromJson(json);
  }

  Future<SocialLinks?> getSocialMediaLinks(int userId) async {
    final raw = await _apiService.get(
      'UserSetup/GetSocialMediaLinks?UserInfoId=$userId',
    );
    if (raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return SocialLinks.fromJson(data);
  }

  Future<ResponseDao> saveDriverLiveTracking(
    DriverLiveTrackingRequest request,
  ) async {
    final json = await _apiService.postJson(
      'Tracking/SaveDriverLiveTrackingAfterTripAccepted',
      request.toJson(),
    );
    return ResponseDao.fromJson(json);
  }

  Future<bool> updateDriverInformationRaw(Map<String, dynamic> body) async {
    final json =
        await _apiService.postJson('UserSetup/UpdateDriverInformation', body);
    return (json['IsSuccess'] ?? false) == true;
  }
}
