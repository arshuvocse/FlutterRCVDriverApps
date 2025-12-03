class UpdateDriverUserRequest {
  final int driverUserId;
  final String password;

  UpdateDriverUserRequest({
    required this.driverUserId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'DriverUserID': driverUserId,
        'Password': password,
      };
}
