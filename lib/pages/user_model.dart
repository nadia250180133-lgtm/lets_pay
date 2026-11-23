class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final bool isEmailVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isEmailVerified = true,
  });

  /// Mengambil inisial huruf depan nama (misal: "Raffi" -> "R")
  String get initial {
    if (name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}