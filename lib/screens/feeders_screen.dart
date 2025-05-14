import 'package:appsigi5/screens/feeder_detail_screen.dart';
import 'package:flutter/material.dart';

class FeedersScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const FeedersScreen({super.key, required this.onThemeChanged});

  @override
  State<FeedersScreen> createState() => _FeedersScreenState();
}

class _FeedersScreenState extends State<FeedersScreen> {
  Future<List<String>> _loadFeeders() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Comedero 1', 'Comedero 2', 'Comedero 3'];
  }

  Future<void> _addFeeder() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      feedersSnapshot.data!.add('Comedero ${feedersSnapshot.data!.length + 1}');
    });
  }

  Future<void> _removeFeeder(int index) async {
    return showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar comedero'),
            content: Text(
              '¿Estás seguro de eliminar ${feedersSnapshot.data![index]}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    feedersSnapshot.data!.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToDetail(String feederName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FeederDetailScreen(
              feederName: feederName,
              onThemeChanged: widget.onThemeChanged,
            ),
      ),
    );
  }

  Widget _buildFeederCard(String feederName, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  Icon(Icons.pets, size: 30, color: Colors.deepPurpleAccent),
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
                    style: TextStyle(color: Colors.deepPurpleAccent),
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
          Icon(Icons.pets, size: 60, color: Colors.deepPurpleAccent[400]),
          const SizedBox(height: 16),
          const Text(
            'No tienes comederos',
            style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(height: 8),
          const Text(
            'Presiona el botón para agregar uno',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
        ],
      ),
    );
  }

  late Future<List<String>> feedersFuture;
  late AsyncSnapshot<List<String>> feedersSnapshot;

  @override
  void initState() {
    super.initState();
    feedersFuture = _loadFeeders();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Comederos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        foregroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(
                isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<String>>(
                future: feedersFuture,
                builder: (context, snapshot) {
                  feedersSnapshot = snapshot;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar los comederos: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _buildFeederCard(snapshot.data![index], index);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            SizedBox(
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
                onPressed: _addFeeder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
