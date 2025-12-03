class DriverUserWithType {
  final int driverUserId;
  final String latValue;
  final String longValue;
  final String addressName;
  final String changeType;

  DriverUserWithType({
    required this.driverUserId,
    required this.latValue,
    required this.longValue,
    required this.addressName,
    required this.changeType,
  });

  Map<String, dynamic> toJson() => {
        'DriverUserID': driverUserId,
        'LatValue': latValue,
        'LongValue': longValue,
        'AddressName': addressName,
        'ChangeType': changeType,
      };
}
