// food_config_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'food_tab.dart'; // Importa la pestaña de Alimentos
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodConfigScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const FoodConfigScreen({super.key, required this.onThemeChanged});

  @override
  State<FoodConfigScreen> createState() => _FoodConfigScreenState();
}

class _FoodConfigScreenState extends State<FoodConfigScreen> {
  List<Map<String, dynamic>> _customFoods = [];
  final Random _random = Random();
  final List<Color> _availableColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
    Colors.amber.shade100,
    Colors.cyan.shade100,
    Colors.lime.shade100,
    Colors.pink.shade100,
  ];
  final List<IconData> _availableIcons = [
    Icons.restaurant,
    Icons.local_dining,
    Icons.fastfood,
    Icons.cake,
    Icons.local_pizza,
    Icons.local_cafe,
    Icons.egg,
    Icons.apple,
    Icons.icecream,
    Icons.dinner_dining,
  ];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Color _getRandomColor() => _availableColors[_random.nextInt(_availableColors.length)];
  IconData _getRandomIcon() => _availableIcons[_random.nextInt(_availableIcons.length)];

  Future<void> _addNewFood(Map<String, String> newFood) async {
    setState(() {
      _customFoods.add({...newFood, 'id': DateTime.now().toString(), 'color': _getRandomColor(), 'icon': _getRandomIcon()});
    });
    await _saveFoods();
  }

  Future<void> _updateFood(String id, Map<String, String> updatedFood) async {
    setState(() {
      final index = _customFoods.indexWhere((food) => food['id'] == id);
      if (index != -1) {
        _customFoods[index] = {..._customFoods[index], ...updatedFood};
      }
    });
    await _saveFoods();
  }

  Future<void> _removeCustomFood(String id) async {
    setState(() {
      _customFoods.removeWhere((food) => food['id'] == id);
    });
    await _saveFoods();
  }

  Future<void> _saveFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFoods = json.encode(_customFoods.map((food) => {
      ...food,
      'color': food['color'] is Color ? food['color'].value.toRadixString(16).padLeft(8, '0') : (food['color'] as Color?)?.value.toRadixString(16).padLeft(8, '0'),
      'icon': food['icon'] is IconData ? food['icon'].codePoint : (food['icon'] as IconData?)?.codePoint,
    }).toList());
    await prefs.setString('customFoods', encodedFoods);
  }

  Future<void> _loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFoods = prefs.getString('customFoods');
    if (storedFoods != null) {
      final List<dynamic> decodedFoods = json.decode(storedFoods);
      setState(() {
        _customFoods = decodedFoods.map<Map<String, dynamic>>((food) => {
          ...food as Map<String, dynamic>,
          'color': food.containsKey('color')
              ? Color(int.parse((food['color'] as String).substring(0, 8), radix: 16))
              : _getRandomColor(),
          'icon': food.containsKey('icon')
              ? IconData(int.parse(food['icon'].toString()), fontFamily: 'MaterialIcons')
              : _getRandomIcon(),
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Alimentos'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FoodTab(
              customFoods: _customFoods,
              onFoodAdded: _addNewFood,
              onFoodUpdated: _updateFood,
              onFoodRemoved: _removeCustomFood,
            ),
    );
  }
}