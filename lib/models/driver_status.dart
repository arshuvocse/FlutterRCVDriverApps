class DriverStatus {
  final int driverStatusId;

  DriverStatus({required this.driverStatusId});

  factory DriverStatus.fromJson(Map<String, dynamic> json) => DriverStatus(
        driverStatusId: json['driverStatusID'] ?? json['DriverStatusID'] ?? 0,
      );
}
