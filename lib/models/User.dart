class User {
  int? id;
  int? profile_id;
  String? email;
  String? name;
  String? description;
  String? profile_Image;
  String? role;
  String? phone;
  User({
    required this.id,
    required this.profile_id,
    required this.email,
    required this.name,
     this.description,
    required this.profile_Image,
    required this.role,
    required this.phone,
  });

  User.initial()
      : id = 0,
        profile_id = 0,
        email = "",
        name = "",
        description = null,
        profile_Image = null,
        role = "worker";

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      profile_id: map['profile_id'] as int?,
      email: map['email'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      profile_Image: map['profile_image'] as String?,
      role: map['role'] as String?,
      phone: map['phone'] as String?,
    );
  }

  bool checkUserID(int id){
    return this.id == id;
  }
}
