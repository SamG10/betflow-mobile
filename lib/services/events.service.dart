import 'package:dio/dio.dart';

class EventsService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchEvents() async {
    try {
      print("call API.......");
      final response = await _dio.get('http://localhost:8080/api/v1/events');

      print(response);

      if (response.statusCode == 200) {
        // La requête a réussi
        final List<dynamic> matches = response.data[0]['matches'];
        return matches;
      } else {
        // La requête a échoué avec une erreur
        print('Failed to fetch data: ${response.statusCode}');
        return []; // Retourne une liste vide en cas d'erreur
      }
    } catch (e) {
      // Une erreur s'est produite lors de la requête
      print('Error fetching data: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }
}
