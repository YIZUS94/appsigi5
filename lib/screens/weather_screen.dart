import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _errorMessage = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = '';
        });
      }

      // Verificación de servicios de ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Por favor activa los servicios de ubicación en tu dispositivo');
      }

      // Verificación de permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permisos de ubicación denegados');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Los permisos de ubicación están permanentemente denegados. Actívalos en configuración');
      }

      // Obtención de ubicación
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Llamada al servicio meteorológico
      final weatherData = await WeatherService.getWeather(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _parseErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  String _parseErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'Error de conexión a internet';
    } else if (error.toString().contains('API Error')) {
      return 'Error del servicio meteorológico';
    } else if (error.toString().contains('Failed to fetch')) {
      return 'No se pudo obtener datos del clima';
    } else if (error.toString().contains('API Key no configurada')) {
      return 'Configuración incompleta: falta la API Key';
    }
    return 'Error: ${error.toString().replaceAll('Exception: ', '')}';
  }

  String _formatDate(int timestamp) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      );
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return _buildLoader();
    if (_errorMessage.isNotEmpty) return _buildError();
    if (_weatherData == null) return _buildEmpty();
    return _buildWeatherUI();
  }

  Widget _buildLoader() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text('Obteniendo datos meteorológicos...'),
      ],
    ),
  );

  Widget _buildError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            _errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchWeather,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );

  Widget _buildEmpty() => const Center(
    child: Text('No se encontraron datos del clima'),
  );

  Widget _buildWeatherUI() {
    final weather = _weatherData!['weather']?[0] ?? {};
    final main = _weatherData!['main'] ?? {};
    final wind = _weatherData!['wind'] ?? {};
    final sys = _weatherData!['sys'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${_weatherData!['name'] ?? 'Ubicación desconocida'}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            _formatDate(_weatherData!['dt'] ?? 0),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                WeatherService.getWeatherIcon(weather['icon'] ?? ''),
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 10),
              Text(
                '${main['temp']?.round() ?? '--'}°C',
                style: const TextStyle(fontSize: 48),
              ),
            ],
          ),
          Text(
            (weather['description']?.toString() ?? 'Desconocido').capitalize(),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          _buildWeatherDetails(main, wind, sys),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(Map<String, dynamic> main, Map<String, dynamic> wind, Map<String, dynamic> sys) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow('Sensación térmica', '${main['feels_like']?.round() ?? '--'}°C'),
            _buildDetailRow('Humedad', '${main['humidity'] ?? '--'}%'),
            _buildDetailRow('Presión', '${main['pressure'] ?? '--'} hPa'),
            _buildDetailRow('Viento', '${wind['speed'] ?? '--'} m/s'),
            _buildDetailRow('Amanecer', _formatDate(sys['sunrise'] ?? 0)),
            _buildDetailRow('Atardecer', _formatDate(sys['sunset'] ?? 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Aquí puedes cancelar cualquier suscripción o animación que estés usando
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (trim().isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}