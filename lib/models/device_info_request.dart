class DeviceInfoRequest {
  final int driverUserId;
  final String deviceId;
  final String deviceModel;
  final String operatingSystem;
  final String osVersion;
  final String appVersion;
  final String deviceToken;
  final String fcmToken;

  DeviceInfoRequest({
    required this.driverUserId,
    required this.deviceId,
    required this.deviceModel,
    required this.operatingSystem,
    required this.osVersion,
    required this.appVersion,
    required this.deviceToken,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        'DriverUserID': driverUserId,
        'DeviceId': deviceId,
        'DeviceModel': deviceModel,
        'OperatingSystem': operatingSystem,
        'OSVersion': osVersion,
        'AppVersion': appVersion,
        'DeviceToken': deviceToken,
        'FCMToken': fcmToken,
      };
}
