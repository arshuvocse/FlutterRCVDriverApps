class TripBanner {
  final String imageUrl;

  TripBanner({required this.imageUrl});

  factory TripBanner.fromJson(Map<String, dynamic> json) => TripBanner(
        imageUrl: (json['categoryImageURL'] ?? '').toString(),
      );
}
