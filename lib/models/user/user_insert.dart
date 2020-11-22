import 'package:flutter/foundation.dart';

class UserManipulation {
  String email;
  String password;
  String name;
  String role;

  UserManipulation({
    @required this.email,
    @required this.password,
    this.name,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {"email": email,"password": password,"name": name,"role": role};
  }
}
