class UserData {
  final String email;
  final String name;
  final String id;
  String skinType;
  List<String> skinConcerns;
  List<String> avoidIngredients;
  Map<String, List<String>> ownedCosmetics;
  String routineId;
  String bsti;
  final DateTime createdAt;
  DateTime updatedAt;
  final String hashedPassword;
  bool sensitive;
  final int age;

  UserData({
    required this.email,
    required this.name,
    required this.id,
    required this.skinType,
    required this.skinConcerns,
    required this.avoidIngredients,
    required this.ownedCosmetics,
    required this.routineId,
    required this.bsti,
    required this.createdAt,
    required this.updatedAt,
    required this.hashedPassword,
    required this.sensitive,
    required this.age,
  });

  // JSON 데이터를 UserData 객체로 변환하는 factory 생성자
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      name: json['name'] ?? '',
      id: json['_id'] ?? '',
      skinType: json['skin_type'] ?? '',
      skinConcerns: json['skin_concerns'] is Iterable
          ? List<String>.from(json['skin_concerns'])
          : [],
      sensitive: (json['has_sensitive_skin'] is bool)
          ? json['has_sensitive_skin']
          : false,
      avoidIngredients: json['avoid_ingredients'] is Iterable
          ? List<String>.from(json['avoid_ingredients'])
          : [],
      ownedCosmetics: json['owned_cosmetics'] is Map
          ? Map<String, List<String>>.from(
              json['owned_cosmetics'].map((key, value) {
                return MapEntry(
                  key,
                  value is Iterable ? List<String>.from(value) : [],
                );
              }),
            )
          : {},
      routineId: json['routine_id'] ?? '',
      bsti: json['bsti'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      hashedPassword: json['hashed_password'] ?? '',
    );
  }

  // BSTI를 반환하는 메서드
  String userBSTI() {
    return bsti;
  }
}

bool isUserDataEmpty(UserData userData) {
  return userData.email.isEmpty &&
      userData.name.isEmpty &&
      userData.id.isEmpty &&
      userData.hashedPassword.isEmpty;
}
