class AllCredentials {
  final String? accountSid;
  final String? authToken;
  final String? twilioPhoneNumber;
  final String? googlePlacesApiKey;

  AllCredentials({
    this.accountSid,
    this.authToken,
    this.twilioPhoneNumber,
    this.googlePlacesApiKey,
  });

  factory AllCredentials.fromJson(Map<String, dynamic> json) => AllCredentials(
        accountSid: json['AccountSID'],
        authToken: json['AuthToken'],
        twilioPhoneNumber: json['TwilioPhoneNumber'],
        googlePlacesApiKey: json['GooglePlacesApiKey'],
      );
}
