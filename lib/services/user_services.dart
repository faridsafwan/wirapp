import 'dart:convert';

import 'package:wiprapp/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:wiprapp/models/user/user.dart';
import 'package:wiprapp/models/user/user_insert.dart';

class UsersService {
  static const API = 'https://wipr.smartcp.app';
  static const headers = {'Content-Type': "application/json"};

  Future<APIResponse<List<User>>> getEventsList() {
    return http.get(API + '/user', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final users = <User>[];
        for (var item in jsonData) {
          users.add(User.fromJson(item));
        }
        return APIResponse<List<User>>(data: users);
      }
      return APIResponse<List<User>>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((_) => APIResponse<List<User>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<User>> getUser(String userID) {
    return http.get(API + '/user/' + userID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<User>(data: User.fromJson(jsonData));
      }
      return APIResponse<User>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<User>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> register(UserManipulation item) {
    return http
        .post(API + '/user/register',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      final jsonData = json.decode(data.body);
      var message = jsonData['message'];
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: message);
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<User>> login(UserManipulation item) {
    return http
        .post(API + '/user/login',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      final jsonData = json.decode(data.body);
      var message = jsonData['message'];

      if (data.statusCode == 200) {
        return APIResponse<User>(data: User.fromJson(jsonData));
      }
      return APIResponse<User>(error: true, errorMessage: message);
    }).catchError((_) =>
            APIResponse<User>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> updateUser(String userID, UserManipulation item) {
    return http
        .put(API + '/user/' + userID,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> deleteUser(String userID) {
    return http.delete(API + '/user/' + userID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }
}
