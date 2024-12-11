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
  final String bsti;
  final bool sensitive;
  final int age;

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
    required this.bsti,
    required this.sensitive,
    required this.age,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] ?? '',
      age: json['age'] ?? '',
      name: json['name'] ?? '',
      id: json['_id'] ?? '',
      skinType: json['skin_type'] ?? '',
      skinConcerns: json['skin_concerns'] is Iterable
          ? List<String>.from(json['skin_concerns'])
          : [],
      sensitive: (json['has_sensitive_skin'] is bool)
          ? json['has_sensitive_skin'] as bool
          : false, // null 또는 빈 문자열은 false로 처리
      avoidIngredients: json['avoid_ingredients'] is Map
          ? Map<String, Map<String, int>>.from(
              json['avoid_ingredients'].map((key, value) {
                return MapEntry(
                  key,
                  value is Map ? Map<String, int>.from(value) : {},
                );
              }),
            )
          : {},
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      hashedPassword: json['hashed_password'] ?? '',
      bsti: json['bsti'] ?? '',
    );
  }
}

bool isUserDataEmpty(UserData userData) {
  return userData.email.isEmpty &&
      userData.name.isEmpty &&
      userData.id.isEmpty &&
      userData.avoidIngredients.isEmpty &&
      userData.hashedPassword.isEmpty &&
      userData.bsti.isEmpty;
}
