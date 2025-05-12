import 'package:flutter/material.dart';

class Esp32ConfigScreen extends StatelessWidget {
  const Esp32ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController ssidController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController ipController = TextEditingController();
    final TextEditingController portController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración ESP32'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(labelText: 'Dirección IP'),
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              decoration: const InputDecoration(labelText: 'Puerto'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para guardar o usar los datos del ESP32
                  String ssid = ssidController.text;
                  String password = passwordController.text;
                  String ip = ipController.text;
                  String port = portController.text;
                  print('SSID: $ssid, Password: $password, IP: $ip, Puerto: $port');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos del ESP32 guardados (simulado)')),
                  );
                  // Puedes decidir si quieres navegar de vuelta a la pantalla anterior aquí
                  // Navigator.pop(context);
                },
                child: const Text('Guardar Configuración'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}