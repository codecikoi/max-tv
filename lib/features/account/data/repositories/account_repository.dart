import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class AccountRepository {
  static const _userKey = 'cached_user';
  final DioClient _dioClient;

  AccountRepository(this._dioClient);

  Future<UserModel> fetchProfile() async {
    final response = await _dioClient.dio.get('/users/me');
    final data = response.data;
    final Map<String, dynamic> json;
    if (data is Map<String, dynamic>) {
      json = data.containsKey('data') && data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
    } else {
      throw Exception('Unexpected response format');
    }
    final user = UserModel.fromJson(json);
    await cacheUser(user);
    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
    required String login,
  }) async {
    await _dioClient.dio.patch('/users/me', data: {
      'name': name,
      'login': login,
    });
    return fetchProfile();
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
