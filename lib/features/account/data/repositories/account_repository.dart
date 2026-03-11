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

  Future<void> toggleNsfw() async {
    await _dioClient.dio.get('/nsfw/toggle');
  }

  Future<void> setNsfwPin(String pin) async {
    await _dioClient.dio.post('/nsfw/set_pin', data: {'pin': pin});
  }

  Future<bool> checkNsfwPin(String pin) async {
    final response = await _dioClient.dio.get('/nsfw/check_pin', queryParameters: {'pin': pin});
    return response.statusCode == 200;
  }

  Future<void> resetNsfwPin(String password) async {
    await _dioClient.dio.get('/nsfw/reset_pin', queryParameters: {'password': password});
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _dioClient.dio.post('/users/send_password_reset_email', data: {
      'email': email,
      'language': 'ru',
    });
  }
}
