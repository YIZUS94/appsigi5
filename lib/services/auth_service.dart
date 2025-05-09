import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  static Database? _database;

  // Inicialización de la base de datos
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'users.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            name TEXT,
            password TEXT,
            createdAt TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Encriptación de contraseña
  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Registro de usuario
  static Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final db = await database;
      await db.insert('users', {
        'email': email.trim(),
        'name': name.trim(),
        'password': _hashPassword(password),
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error en registro: $e');
      return false;
    }
  }

  // Inicio de sesión
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email.trim(), _hashPassword(password)],
      );

      if (result.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email.trim());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error en login: $e');
      return false;
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  // Verificar sesión activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') != null;
  }

  // Obtener usuario actual
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      if (email == null) return null;

      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('Error en getCurrentUser: $e');
      return null;
    }
  }
}