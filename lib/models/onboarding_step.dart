class OnboardingStep {
  final String title;
  final String description;

  OnboardingStep({
    required this.title,
    required this.description,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      title: (json['title'] ?? json['Title'] ?? '').toString(),
      description: (json['description'] ?? json['Description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Title': title,
        'Description': description,
      };
}
