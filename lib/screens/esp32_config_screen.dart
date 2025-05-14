import 'package:flutter/material.dart';

class Esp32ConfigScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const Esp32ConfigScreen({super.key, required this.onThemeChanged});

  @override
  State<Esp32ConfigScreen> createState() => _Esp32ConfigScreenState();
}

class _Esp32ConfigScreenState extends State<Esp32ConfigScreen> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveEsp32Config() async {
    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    String ssid = _ssidController.text;
    String password = _passwordController.text;
    String ip = _ipController.text;
    String port = _portController.text;
    print('SSID: $ssid, Password: $password, IP: $ip, Puerto: $port');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos del ESP32 guardados (simulado)')),
      );
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración ESP32'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(labelText: 'Dirección IP'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(labelText: 'Puerto'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveEsp32Config,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Guardar Configuración'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}