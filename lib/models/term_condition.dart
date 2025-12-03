class TermCondition {
  final String serialNo;
  final String title;
  final String description;

  TermCondition({
    required this.serialNo,
    required this.title,
    required this.description,
  });

  factory TermCondition.fromJson(Map<String, dynamic> json) => TermCondition(
        serialNo: (json['serialNo'] ?? json['SerialNo'] ?? '').toString(),
        title: (json['Title'] ?? '').toString(),
        description: (json['Description'] ?? '').toString(),
      );
}
