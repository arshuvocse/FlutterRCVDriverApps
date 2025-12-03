class DriverShiftUpdate {
  final int driverUserId;
  final int driverStatusId;

  DriverShiftUpdate({
    required this.driverUserId,
    required this.driverStatusId,
  });

  Map<String, dynamic> toJson() => {
        'DriverUserID': driverUserId,
        'DriverStatusID': driverStatusId,
      };
}
