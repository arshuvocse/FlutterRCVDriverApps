class SignInRequest {
  final String mobileNumber;
  final String password;

  SignInRequest({required this.mobileNumber, required this.password});

  Map<String, dynamic> toJson() => {
        'MobileNumber': mobileNumber,
        'Password': password,
      };
}
