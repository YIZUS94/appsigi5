import 'package:flutter/material.dart';

class FeederDetailScreen extends StatefulWidget {
  final String feederName;
  final Function(ThemeMode) onThemeChanged;

  const FeederDetailScreen({super.key, required this.feederName, required this.onThemeChanged});

  @override
  State<FeederDetailScreen> createState() => _FeederDetailScreenState();
}

class _FeederDetailScreenState extends State<FeederDetailScreen> {
  String _batteryLevel = 'Cargando...';
  String _foodRemaining = 'Cargando...';
  String _lastRefill = 'Cargando...';
  String _location = 'Cargando...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeederDetails();
  }

  Future<void> _loadFeederDetails() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _batteryLevel = '85%';
      _foodRemaining = '75%';
      _lastRefill = 'Hoy 10:30 AM';
      _location = 'Patio trasero';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feederName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 50, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 10),
                        Text(
                          widget.feederName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailCard(
                    context,
                    title: 'Información del Comedero',
                    items: [
                      _buildDetailItem(Icons.battery_full, 'Batería', _batteryLevel),
                      _buildDetailItem(Icons.food_bank, 'Comida restante', _foodRemaining),
                      _buildDetailItem(Icons.schedule, 'Última recarga', _lastRefill),
                      _buildDetailItem(Icons.location_on, 'Ubicación', _location),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}