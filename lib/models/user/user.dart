class User {
  String userID;
  String email;
  String password;
  String name;
  String role;

  User({
    this.userID,
    this.email,
    this.password,
    this.name,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> item) {
    return User(
      userID: item['userID'],
      email: item['email'],
      password: item['password'],
      name: item['name'],
      role: item['role'],
    );
  }
}
