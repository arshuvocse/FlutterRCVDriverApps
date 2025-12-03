class ResponseDao {
  final bool isSuccess;
  final int pkid;
  final int userTypeId;
  final bool isError;
  final String errorMessage;
  final String errorMessageNew;
  final String otpCode;

  ResponseDao({
    required this.isSuccess,
    required this.pkid,
    required this.userTypeId,
    required this.isError,
    required this.errorMessage,
    required this.errorMessageNew,
    required this.otpCode,
  });

  factory ResponseDao.fromJson(Map<String, dynamic> json) => ResponseDao(
        isSuccess: json['IsSuccess'] ?? false,
        pkid: json['Pkid'] ?? 0,
        userTypeId: json['UserTypeId'] ?? 0,
        isError: json['IsError'] ?? false,
        errorMessage: json['ErrorMessage'] ?? '',
        errorMessageNew: json['ErrorMessageNew'] ?? '',
        otpCode: json['OtpCode'] ?? '',
      );
}
