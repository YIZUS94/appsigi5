import 'package:flutter/material.dart';

class FeederDetailScreen extends StatelessWidget {
  final String feederName;

  const FeederDetailScreen({super.key, required this.feederName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feederName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                    feederName,
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
                _buildDetailItem(Icons.battery_full, 'Batería', '85%'),
                _buildDetailItem(Icons.food_bank, 'Comida restante', '75%'),
                _buildDetailItem(Icons.schedule, 'Última recarga', 'Hoy 10:30 AM'),
                _buildDetailItem(Icons.location_on, 'Ubicación', 'Patio trasero'),
              ],
            ),
            const Spacer(),
            _ConfigButton(
              onPressed: () {
                // Acción para configurar
              },
            ),
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

class _ConfigButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ConfigButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.settings, color: Colors.white),
        label: const Text(
          'Configurar Comedero',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}