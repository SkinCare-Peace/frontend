class UserData {
  final String email;
  final String name;
  final String id;
  final String skinType;
  final List<String> skinConcerns;
  final Map<String, Map<String, int>> avoidIngredients;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String hashedPassword;

  UserData({
    required this.email,
    required this.name,
    required this.id,
    required this.skinType,
    required this.skinConcerns,
    required this.avoidIngredients,
    required this.createdAt,
    required this.updatedAt,
    required this.hashedPassword,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      name: json['name'],
      id: json['_id'],
      skinType: json['skin_type'],
      skinConcerns: List<String>.from(json['skin_concerns']),
      avoidIngredients: Map<String, Map<String, int>>.from(
        json['avoid_ingredients'].map((key, value) {
          return MapEntry(
            key,
            Map<String, int>.from(value),
          );
        }),
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      hashedPassword: json['hashed_password'],
    );
  }
}
