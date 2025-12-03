class RegisterUserRequest {
  final String vehicletypeId;
  final String fullName;
  final String trafficPlateNo;
  final String tcNo;
  final String companyName;
  final String nationality;
  final String mobileNumber;
  final String password;
  final String imageBase64String;
  final String driverFrontImageBase64String;
  final String driverImageInfo;
  final String latValue;
  final String longValue;
  final String addressName;
  final bool termsAccepted;

  RegisterUserRequest({
    required this.vehicletypeId,
    required this.fullName,
    required this.trafficPlateNo,
    required this.tcNo,
    required this.companyName,
    required this.nationality,
    required this.mobileNumber,
    required this.password,
    required this.imageBase64String,
    required this.driverFrontImageBase64String,
    required this.driverImageInfo,
    required this.latValue,
    required this.longValue,
    required this.addressName,
    required this.termsAccepted,
  });

  Map<String, dynamic> toJson() => {
        'VehicletypeID': vehicletypeId,
        'FullName': fullName,
        'TrafficPlateNo': trafficPlateNo,
        'TCNo': tcNo,
        'CompanyName': companyName,
        'Nationality': nationality,
        'MobileNumber': mobileNumber,
        'Password': password,
        'ImageBase64String': imageBase64String,
        'DriverFrontImageBase64String': driverFrontImageBase64String,
        'DriverImageInfo': driverImageInfo,
        'LatValue': latValue,
        'LongValue': longValue,
        'AddressName': addressName,
        'TermsAccepted': termsAccepted,
      };
}
