import 'package:flutter/material.dart';
import 'supplies_screen.dart'; // Importa la pantalla de Insumos
import 'vaccines_screen.dart'; // Importa la pantalla de Vacunas// Importa la pantalla de Alimentos
import 'food_config_screen.dart';
import 'auth_screen.dart';
import 'feeders_screen.dart';
import 'pricing_screen.dart';
import 'weather_screen.dart';
import 'package:appsigi5/services/auth_service.dart';
import 'package:appsigi5/widgets/menu_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Importa el paquete de iconos

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PorciTech', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8.0),
            const Icon(
              MaterialCommunityIcons.pig, // Usa el mismo icono de cerdo
              size: 24.0,
              color: Color.fromARGB(255, 255, 0, 187), // Ajusta el color si es necesario
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 150.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: [
              _buildSliderItem('Consejo: Asegúrate de proporcionar alimento de calidad y en las cantidades adecuadas según la etapa de crecimiento de tus cerdos.', Colors.lightGreen),
              _buildSliderItem('Dato importante: Un ambiente limpio y seco reduce el riesgo de enfermedades en tu piara.', Colors.lightBlue),
              _buildSliderItem('Recomendación: Realiza mantenimientos periódicos a tus comederos automáticos para asegurar su óptimo funcionamiento.', Colors.orange),
              _buildSliderItem('Consideración: Evalúa la densidad de animales por comedero para evitar la competencia excesiva por el alimento.', Colors.purple),
              _buildSliderItem('Consejo: Lleva un registro detallado de tus costos de producción para identificar áreas de mejora en la eficiencia de tu granja.', Colors.amber),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  MenuCard(
                    icon: Icons.food_bank,
                    title: 'Comederos',
                    color: Colors.blue[700]!,
                    onTap: () => _navigateTo(context, const FeedersScreen()),
                  ),
                  MenuCard(
                    icon: Icons.cloud,
                    title: 'Clima',
                    color: Colors.green[700]!,
                    onTap: () => _navigateTo(context, const WeatherScreen()),
                  ),
                  MenuCard(
                    icon: Icons.attach_money,
                    title: 'Crecimiento',
                    color: Colors.orange[700]!,
                    onTap: () => _navigateTo(context, const PricingScreen()),
                  ),
                  MenuCard(
                    icon: Icons.cookie_outlined,
                    title: 'Alimento',
                    color: const Color.fromARGB(255, 112, 73, 0),
                    onTap: () => _navigateTo(context, const FoodConfigScreen()),
                  ),
                  // Botón para Vacunas
                  MenuCard(
                    icon: Icons.vaccines,
                    title: 'Vacunas',
                    color: Colors.red[700]!,
                    onTap: () => _navigateTo(context, const VaccinesScreen()),
                  ),
                  // Botón para Insumos
                  MenuCard(
                    icon: Icons.shopping_cart,
                    title: 'Insumos',
                    color: Colors.purple[700]!,
                    onTap: () => _navigateTo(context, const InsumosScreen()), // Removí 'const' aquí
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSliderItem(String text, Color color) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color.withOpacity(0.8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Módulo en desarrollo'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}