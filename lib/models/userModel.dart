class UserModel {
  UserModel({required this.username, required this.role});
  String username;

  String role;

    factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['USERID'],
      role: json['PROFILEID'],
    );
  }
}
