import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // 1. ¡PON TU API KEY AQUÍ! (Reemplaza el texto entre comillas)
  static const String _apiKey = 'cb4affee9f18f4ac3625a2043764e1a0'; // 🔑
  
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    // Verifica que la API key esté configurada
    if (_apiKey.isEmpty || _apiKey.contains('PON_TU_API_KEY')) {
      throw Exception('API Key no configurada. Por favor actualiza weather_service.dart');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es'),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  static String getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}