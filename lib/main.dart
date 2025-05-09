import 'package:flutter/material.dart';
import 'package:appsigi5/screens/auth_screen.dart';
import 'package:appsigi5/screens/home_screen.dart';
import 'package:appsigi5/screens/register_screen.dart';
import 'package:appsigi5/services/auth_service.dart';

void main() async {
  // Asegurar que Flutter esté inicializadozxcvbn
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar la base de datos
  await AuthService.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App SIGI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/auth', // <- Cambia '/' por '/auth'
      routes: {
        '/': (context) => const AuthWrapper(),
        '/auth': (context) => const AuthScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const HomeScreen() : const AuthScreen();
        }
      },
    );
  }
}