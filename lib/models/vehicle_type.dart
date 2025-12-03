class VehicleType {
  final int id;
  final String name;

  VehicleType({required this.id, required this.name});

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json['VehicletypeID'] as int,
        name: (json['VehicletypeName'] ?? '').toString(),
      );
}
