class MrzParser {
  ParsedMrz parse(String text) => ParsedMrz();
}

class ParsedMrz {
  final String? name;
  final String? country;
  final String? cardNumber;
  final String? trafficPlateNo;
  final String? employer;

  ParsedMrz({
    this.name,
    this.country,
    this.cardNumber,
    this.trafficPlateNo,
    this.employer,
  });
}
