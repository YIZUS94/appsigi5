// food_tab.dart
import 'package:flutter/material.dart';

class _AddEditFoodDialog extends StatefulWidget {
  final Map<String, dynamic>? initialFood;
  final Function(Map<String, String>) onFoodAdded;
  final Function(String, Map<String, String>)? onFoodUpdated; // Añadido onFoodUpdated

  const _AddEditFoodDialog({Key? key, this.initialFood, required this.onFoodAdded, this.onFoodUpdated}) : super(key: key);

  @override
  State<_AddEditFoodDialog> createState() => _AddEditFoodDialogState();
}

class _AddEditFoodDialogState extends State<_AddEditFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  String? stage;
  String? price;

  @override
  void initState() {
    super.initState();
    if (widget.initialFood != null) {
      name = widget.initialFood!['name'];
      description = widget.initialFood!['description'];
      stage = widget.initialFood!['stage'];
      price = widget.initialFood!['price'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialFood == null ? 'Agregar Nuevo Alimento' : 'Editar Alimento'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nombre del Alimento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del alimento';
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Etapa Recomendada'),
                value: stage,
                items: <String>['Lechones', 'Crecimiento', 'Engorde', 'Reproducción']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona la etapa recomendada';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    stage = newValue;
                  });
                },
                onSaved: (value) => stage = value,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Descripción (Opcional)'),
                onSaved: (value) => description = value,
              ),
              TextFormField(
                initialValue: price,
                decoration: const InputDecoration(labelText: 'Precio por Unidad (ej: 10.00 MXN/kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el precio por unidad';
                  }
                  return null;
                },
                onSaved: (value) => price = value,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.initialFood == null ? 'Agregar' : 'Guardar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final updatedFood = {
                'name': name!,
                'description': description ?? '',
                'stage': stage!,
                'price': price!,
              };
              if (widget.initialFood == null) {
                widget.onFoodAdded(updatedFood);
              } else {
                widget.onFoodUpdated?.call(widget.initialFood!['id']!, updatedFood); // Usar el callback onFoodUpdated
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class _RecommendedFoodsList extends StatelessWidget {
  const _RecommendedFoodsList();

  final List<Map<String, dynamic>> _recommendedFoods = const [
    {
      'id': 'recommended_1',
      'name': 'Alimento Iniciador Lechones (Pellet)',
      'description': 'Alimento completo para lechones desde el destete hasta las 8 semanas. Alto en proteína y energía.',
      'stage': 'Lechones',
      'price': '15.00 MXN/kg',
      'color': Colors.grey,
      'icon': Icons.food_bank,
    },
    {
      'id': 'recommended_2',
      'name': 'Alimento Crecimiento (Harina Gruesa)',
      'description': 'Alimento balanceado para la etapa de crecimiento, desde las 8 hasta las 20 semanas. Contiene fibra para un buen desarrollo.',
      'stage': 'Crecimiento',
      'price': '12.50 MXN/kg',
      'color': Colors.grey,
      'icon': Icons.food_bank,
    },
    {
      'id': 'recommended_3',
      'name': 'Alimento Engorde (Harina Fina)',
      'description': 'Alimento formulado para la fase final de engorde, desde las 20 semanas hasta el sacrificio. Promueve la ganancia de peso.',
      'stage': 'Engorde',
      'price': '11.00 MXN/kg',
      'color': Colors.grey,
      'icon': Icons.food_bank,
    },
    {
      'id': 'recommended_4',
      'name': 'Alimento Reproducción (Pellet Enriquecido)',
      'description': 'Alimento especial para cerdas gestantes y lactantes, y para verracos. Rico en vitaminas y minerales.',
      'stage': 'Reproducción',
      'price': '18.00 MXN/kg',
      'color': Colors.grey,
      'icon': Icons.food_bank,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recommendedFoods.length,
      itemBuilder: (context, index) {
        final food = _recommendedFoods[index];
        return Card(
          color: food['color'] is Color ? food['color'] as Color : Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(food['icon'] as IconData? ?? Icons.food_bank, color: Colors.brown.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Descripción: ${food['description']!}'),
                      Text('Etapa: ${food['stage']!}'),
                      Text('Precio: ${food['price']!}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FoodTab extends StatelessWidget {
  final List<Map<String, dynamic>> customFoods;
  final Function(Map<String, String>) onFoodAdded;
  final Function(String, Map<String, String>) onFoodUpdated;
  final Function(String) onFoodRemoved;

  const FoodTab({
    Key? key,
    required this.customFoods,
    required this.onFoodAdded,
    required this.onFoodUpdated,
    required this.onFoodRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _AddEditFoodDialog(onFoodAdded: onFoodAdded);
            },
          );
        },
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Alimentos Recomendados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const _RecommendedFoodsList(), // Widget separado para los alimentos recomendados
          if (customFoods.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Alimentos Adicionales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customFoods.length,
              itemBuilder: (context, index) {
                final food = customFoods[index];
                return Card(
                  color: food['color'] is Color ? food['color'] as Color : Colors.grey.shade100,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(food['icon'] as IconData? ?? Icons.food_bank, color: Colors.brown.shade400),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Descripción: ${food['description']!}'),
                              Text('Etapa: ${food['stage']!}'),
                              Text('Precio: ${food['price']!}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _AddEditFoodDialog(
                                  initialFood: food,
                                  onFoodAdded: onFoodAdded,
                                  onFoodUpdated: onFoodUpdated, // Pasar onFoodUpdated
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onFoodRemoved(food['id']!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}