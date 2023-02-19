class Profile {
  late String id;
  late String role;
  late String fullName;
  late String email;
  Profile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });
  Profile.fromJson(Map<String, dynamic>? json, String d) {
    id = d;
    role = json?['role'];
    fullName = json?['full_name'];
    email = json?['email'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['full_name'] = fullName;
    data['email'] = email;
    return data;
  }
}
