class DriverUser {
  final int driverUserId;
  final String driverUserCode;
  final String fullName;
  final String trafficPlateNo;
  final String tcNo;
  final String companyName;
  final String nationality;
  final String mobileNumber;
  final String latValue;
  final String longValue;
  final String addressName;
  final String driverBalance;
  final String driverPayToCompany;
  final String lastServiceDate;
  final String bankName;
  final String accountNumber;
  final String iban;
  final String swiftCode;
  final String branchName;
  final String lastWithdrawDate;
  final String lastWithdrawAmount;
  final String withdrawStatus;

  DriverUser({
    required this.driverUserId,
    required this.driverUserCode,
    required this.fullName,
    required this.trafficPlateNo,
    required this.tcNo,
    required this.companyName,
    required this.nationality,
    required this.mobileNumber,
    required this.latValue,
    required this.longValue,
    required this.addressName,
    required this.driverBalance,
    required this.driverPayToCompany,
    required this.lastServiceDate,
    required this.bankName,
    required this.accountNumber,
    required this.iban,
    required this.swiftCode,
    required this.branchName,
    required this.lastWithdrawDate,
    required this.lastWithdrawAmount,
    required this.withdrawStatus,
  });

  factory DriverUser.fromJson(Map<String, dynamic> json) => DriverUser(
        driverUserId: json['DriverUserID'] ?? 0,
        driverUserCode: (json['DriverUserCode'] ?? '').toString(),
        fullName: (json['FullName'] ?? '').toString(),
        trafficPlateNo: (json['TrafficPlateNo'] ?? '').toString(),
        tcNo: (json['TcNo'] ?? '').toString(),
        companyName: (json['CompanyName'] ?? '').toString(),
        nationality: (json['Nationality'] ?? '').toString(),
        mobileNumber: (json['MobileNumber'] ?? '').toString(),
        latValue: (json['LatValue'] ?? '').toString(),
        longValue: (json['LongValue'] ?? '').toString(),
        addressName: (json['AddressName'] ?? '').toString(),
        driverBalance: (json['DriverBalance'] ?? '0').toString(),
        driverPayToCompany: (json['DriverPayToCompany'] ?? '').toString(),
        lastServiceDate: (json['LastServiceDate'] ?? '').toString(),
        bankName: (json['BankName'] ?? 'N/A').toString(),
        accountNumber: (json['AccountNumber'] ?? 'N/A').toString(),
        iban: (json['IBAN'] ?? 'N/A').toString(),
        swiftCode: (json['SwiftCode'] ?? 'N/A').toString(),
        branchName: (json['BranchName'] ?? 'N/A').toString(),
        lastWithdrawDate: (json['LastWithdrawDate'] ?? 'N/A').toString(),
        lastWithdrawAmount: (json['LastWithdrawAmount'] ?? '0').toString(),
        withdrawStatus: (json['WithdrawStatus'] ?? 'Pending').toString(),
      );
}
