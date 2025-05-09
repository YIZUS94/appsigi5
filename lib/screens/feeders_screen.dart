import 'package:appsigi5/screens/feeder_detail_screen.dart';
import 'package:flutter/material.dart';

class FeedersScreen extends StatefulWidget {
  const FeedersScreen({super.key});

  @override
  State<FeedersScreen> createState() => _FeedersScreenState();
}

class _FeedersScreenState extends State<FeedersScreen> {
  List<String> feeders = ['Comedero 1', 'Comedero 2', 'Comedero 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Comederos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: feeders.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: feeders.length,
                      itemBuilder: (context, index) {
                        return _buildFeederCard(feeders[index], index);
                      },
                    ),
            ),
            const SizedBox(height: 16),
            _AddFeederButton(onPressed: _addFeeder),
          ],
        ),
      ),
    );
  }

  Widget _buildFeederCard(String feederName, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _navigateToDetail(feederName),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.pets, size: 30, color: Theme.of(context).primaryColor),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFeeder(index),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feederName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estado: Activo',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No tienes comederos',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Presiona el botón para agregar uno',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _addFeeder() {
    setState(() {
      feeders.add('Comedero ${feeders.length + 1}');
    });
  }

  void _removeFeeder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar comedero'),
        content: Text('¿Estás seguro de eliminar ${feeders[index]}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                feeders.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(String feederName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeederDetailScreen(feederName: feederName),
      ),
    );
  }
}

class _AddFeederButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddFeederButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Agregar Comedero',
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