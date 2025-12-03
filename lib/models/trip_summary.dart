class TripSummary {
  final int tripId;
  final String title;
  final String body;
  final String customerName;
  final String customerMobile;
  final String status;

  TripSummary({
    required this.tripId,
    required this.title,
    required this.body,
    required this.customerName,
    required this.customerMobile,
    required this.status,
  });

  factory TripSummary.fromJson(Map<String, dynamic> json) => TripSummary(
        tripId: json['TripId'] ?? 0,
        title: (json['Title'] ?? '').toString(),
        body: (json['Body'] ?? '').toString(),
        customerName: (json['CustomerName'] ?? '').toString(),
        customerMobile: (json['CustomerMobile'] ?? '').toString(),
        status: (json['Status'] ?? '').toString(),
      );
}
