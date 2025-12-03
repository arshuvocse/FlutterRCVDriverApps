class DriverLiveTrackingRequest {
  final int tripId;
  final int driverUserId;
  final String acceptedTripStatus;
  final String userAddress;
  final String userLatitude;
  final String userLongitude;
  final String driverAddress;
  final String driverLatitude;
  final String driverLongitude;
  final int? customerUserId;

  DriverLiveTrackingRequest({
    required this.tripId,
    required this.driverUserId,
    required this.acceptedTripStatus,
    required this.userAddress,
    required this.userLatitude,
    required this.userLongitude,
    required this.driverAddress,
    required this.driverLatitude,
    required this.driverLongitude,
    this.customerUserId,
  });

  Map<String, dynamic> toJson() => {
        'TripId': tripId,
        'DriverUserID': driverUserId,
        'AcceptedTripStatus': acceptedTripStatus,
        'UserAddress': userAddress,
        'UserLatitude': userLatitude,
        'UserLongitude': userLongitude,
        'DriverAddress': driverAddress,
        'DriverLatitude': driverLatitude,
        'DriverLongitude': driverLongitude,
        'CustomerUserId': customerUserId,
      };
}
