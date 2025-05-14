import 'package:flutter/material.dart';
import 'package:appsigi5/screens/auth_screen.dart';
import 'package:appsigi5/screens/home_screen.dart';
import 'package:appsigi5/screens/register_screen.dart';
import 'package:appsigi5/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'dark') {
      setState(() {
        _themeMode = ThemeMode.dark;
      });
    } else if (theme == 'light') {
      setState(() {
        _themeMode = ThemeMode.light;
      });
    }
  }

  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.dark) {
      await prefs.setString('theme', 'dark');
    } else if (mode == ThemeMode.light) {
      await prefs.setString('theme', 'light');
    } else {
      await prefs.remove('theme');
    }
  }

  void _changeTheme(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
    _saveThemePreference(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PorciTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey[800]),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: _themeMode,
      initialRoute: '/', // Usamos la AuthWrapper para la lógica inicial
      routes: {
        '/': (context) => AuthWrapper(onThemeChanged: _changeTheme),
        '/auth': (context) => AuthScreen(onThemeChanged: _changeTheme),
        '/register': (context) => const RegisterScreen(), // RegisterScreen no parece necesitar el tema
        '/home': (context) => HomeScreen(onThemeChanged: _changeTheme),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  const AuthWrapper({super.key, required this.onThemeChanged});

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
          return isLoggedIn ? HomeScreen(onThemeChanged: onThemeChanged) : AuthScreen(onThemeChanged: onThemeChanged);
        }
      },
    );
  }
}