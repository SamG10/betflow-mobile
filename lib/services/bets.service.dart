import 'package:betflow_mobile_app/services/auth.service.dart';
import 'package:dio/dio.dart';

class BetsService {
  final Dio _dio = Dio();
  final AuthService authService = AuthService();

  Future<void> createBets(List<Map<String, dynamic>> bets) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token is null');
    try {
      Response response = await _dio.post(
        'http://localhost:8080/api/v1/bets',
        data: bets,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response.data);
    } catch (error) {
      print('Error saving bets: $error');
      throw error;
    }
  }
}
