class WithdrawRequest {
  final double amount;
  final int driverUserId;

  WithdrawRequest({required this.amount, required this.driverUserId});

  Map<String, dynamic> toJson() => {
        'Amount': amount,
        'DriverUserID': driverUserId,
      };
}
