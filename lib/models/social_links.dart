class SocialLinks {
  final String facebook;
  final String instagram;
  final String linkedIn;
  final String twitter;

  SocialLinks({
    required this.facebook,
    required this.instagram,
    required this.linkedIn,
    required this.twitter,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
        facebook: (json['Facebook'] ?? '').toString(),
        instagram: (json['Instagram'] ?? '').toString(),
        linkedIn: (json['LinkedIn'] ?? '').toString(),
        twitter: (json['Twitter'] ?? '').toString(),
      );
}
