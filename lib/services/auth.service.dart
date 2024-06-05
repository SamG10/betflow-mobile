import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio.Dio _dio = Dio.Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> register(String username, String password) async {
    final response =
        await _dio.post('http://localhost:8080/api/v1/auth/register', data: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      await _storage.write(key: 'jwt', value: response.data['access_token']);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String username, String password) async {
    final response =
        await _dio.post('http://localhost:8080/api/v1/auth/login', data: {
      'email': username,
      'password': password,
    });

    print(response);

    if (response.statusCode == 201) {
      await _storage.write(key: 'jwt', value: response.data['access_token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Future<Dio.Response> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Token is null');
      final response = await _dio.get(
        'http://localhost:8080/api/v1/auth/profile',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      return response;
    } catch (e) {
      print('Error getting profile: $e');
      throw e;
    }
  }

  Future<Dio.Response> getUserById(String id) async {
    final token = await getToken();
    if (token == null) throw Exception('Token is null');
    try {
      final response = await _dio.get(
        'http://localhost:8080/api/v1/users/$id',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      return response;
    } catch (e) {
      print('Error getting user by id: $e');
      throw e;
    }
  }
}
