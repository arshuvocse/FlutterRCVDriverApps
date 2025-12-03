class VerifyOtpRequest {
  final String mobileNumber;
  final String otpCode;

  VerifyOtpRequest({
    required this.mobileNumber,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
        'MobileNumber': mobileNumber,
        'OTPCode': otpCode,
      };
}
