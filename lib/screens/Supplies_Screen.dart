import 'package:flutter/material.dart';
import '../models/insumo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

class _InsumosScreenState extends State<InsumosScreen> {
  List<Insumo> _insumos = [];
  List<String> _etapasPuerco = ['Lechón', 'Crecimiento', 'Engorde', 'Reproducción'];
  List<String> _unidadesMedida = ['kg', 'litros', 'unidad', 'saco'];
  List<String> _insumosRecomendados = [
    'Alimento iniciador (Lechón)',
    'Suplemento vitamínico (Crecimiento)',
    'Alimento de engorde (Engorde)',
    'Sales minerales (Reproducción)',
  ];

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  String? _unidadMedidaSeleccionada;
  DateTime? _fechaCompraSeleccionada;
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  String? _etapaPuercoSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadInsumos();
  }

  Future<void> _loadInsumos() async {
    final prefs = await SharedPreferences.getInstance();
    final storedInsumos = prefs.getString('insumos');
    if (storedInsumos != null) {
      final List<dynamic> decodedList = json.decode(storedInsumos);
      setState(() {
        _insumos = decodedList.map((item) => Insumo.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveInsumos() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = json.encode(_insumos.map((insumo) => insumo.toJson()).toList());
    await prefs.setString('insumos', encodedList);
  }

  Future<void> _agregarInsumo() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Insumo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Insumo'),
                ),
                TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Unidad de Medida'),
                  value: _unidadMedidaSeleccionada,
                  items: _unidadesMedida.map((unidad) => DropdownMenuItem(value: unidad, child: Text(unidad))).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _unidadMedidaSeleccionada = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una unidad de medida';
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _fechaCompraSeleccionada ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaCompraSeleccionada = pickedDate;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Fecha de Compra'),
                    child: Text(
                      _fechaCompraSeleccionada == null ? 'Seleccionar fecha' : DateFormat('yyyy-MM-dd').format(_fechaCompraSeleccionada!),
                    ),
                  ),
                ),
                TextField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: _costoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Costo'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Etapa del Puerco'),
                  value: _etapaPuercoSeleccionada,
                  items: _etapasPuerco.map((etapa) => DropdownMenuItem(value: etapa, child: Text(etapa))).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _etapaPuercoSeleccionada = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una etapa del puerco';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_nombreController.text.isNotEmpty &&
                    _cantidadController.text.isNotEmpty &&
                    _unidadMedidaSeleccionada != null &&
                    _fechaCompraSeleccionada != null &&
                    _marcaController.text.isNotEmpty &&
                    _costoController.text.isNotEmpty &&
                    _etapaPuercoSeleccionada != null) {
                  final nuevoInsumo = Insumo(
                    nombre: _nombreController.text,
                    cantidad: double.parse(_cantidadController.text),
                    unidadMedida: _unidadMedidaSeleccionada!,
                    fechaCompra: _fechaCompraSeleccionada!,
                    marca: _marcaController.text,
                    costo: double.parse(_costoController.text),
                    etapaPuerco: _etapaPuercoSeleccionada!,
                  );
                  setState(() {
                    _insumos.add(nuevoInsumo);
                    _saveInsumos();
                    _nombreController.clear();
                    _cantidadController.clear();
                    _unidadMedidaSeleccionada = null;
                    _fechaCompraSeleccionada = null;
                    _marcaController.clear();
                    _costoController.clear();
                    _etapaPuercoSeleccionada = null;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarInsumo(Insumo insumo) async {
    _nombreController.text = insumo.nombre;
    _cantidadController.text = insumo.cantidad.toString();
    _unidadMedidaSeleccionada = insumo.unidadMedida;
    _fechaCompraSeleccionada = insumo.fechaCompra;
    _marcaController.text = insumo.marca;
    _costoController.text = insumo.costo.toString();
    _etapaPuercoSeleccionada = insumo.etapaPuerco;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Insumo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Insumo'),
                ),
                TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Unidad de Medida'),
                  value: _unidadMedidaSeleccionada,
                  items: _unidadesMedida.map((unidad) => DropdownMenuItem(value: unidad, child: Text(unidad))).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _unidadMedidaSeleccionada = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una unidad de medida';
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _fechaCompraSeleccionada ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaCompraSeleccionada = pickedDate;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Fecha de Compra'),
                    child: Text(
                      _fechaCompraSeleccionada == null ? 'Seleccionar fecha' : DateFormat('yyyy-MM-dd').format(_fechaCompraSeleccionada!),
                    ),
                  ),
                ),
                TextField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: _costoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Costo'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Etapa del Puerco'),
                  value: _etapaPuercoSeleccionada,
                  items: _etapasPuerco.map((etapa) => DropdownMenuItem(value: etapa, child: Text(etapa))).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _etapaPuercoSeleccionada = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una etapa del puerco';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_nombreController.text.isNotEmpty &&
                    _cantidadController.text.isNotEmpty &&
                    _unidadMedidaSeleccionada != null &&
                    _fechaCompraSeleccionada != null &&
                    _marcaController.text.isNotEmpty &&
                    _costoController.text.isNotEmpty &&
                    _etapaPuercoSeleccionada != null) {
                  final index = _insumos.indexOf(insumo);
                  if (index != -1) {
                    final insumoActualizado = Insumo(
                      nombre: _nombreController.text,
                      cantidad: double.parse(_cantidadController.text),
                      unidadMedida: _unidadMedidaSeleccionada!,
                      fechaCompra: _fechaCompraSeleccionada!,
                      marca: _marcaController.text,
                      costo: double.parse(_costoController.text),
                      etapaPuerco: _etapaPuercoSeleccionada!,
                    );
                    setState(() {
                      _insumos[index] = insumoActualizado;
                      _saveInsumos();
                      _nombreController.clear();
                      _cantidadController.clear();
                      _unidadMedidaSeleccionada = null;
                      _fechaCompraSeleccionada = null;
                      _marcaController.clear();
                      _costoController.clear();
                      _etapaPuercoSeleccionada = null;
                    });
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarInsumo(Insumo insumo) async {
    setState(() {
      _insumos.remove(insumo);
      _saveInsumos();
    });
  }

  Widget _buildInsumoCard(Insumo insumo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${insumo.nombre}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Cantidad: ${insumo.cantidad} ${insumo.unidadMedida}'),
            Text('Fecha de Compra: ${DateFormat('yyyy-MM-dd').format(insumo.fechaCompra)}'),
            Text('Marca: ${insumo.marca}'),
            Text('Costo: ${insumo.costo}'),
            Text('Etapa del Puerco: ${insumo.etapaPuerco}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editarInsumo(insumo),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _eliminarInsumo(insumo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _agregarInsumo,
              child: const Text('Agregar Insumo'),
            ),
            const SizedBox(height: 20),
            const Text('Lista de Insumos:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            _insumos.isEmpty
                ? const Text('No hay insumos registrados.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _insumos.length,
                    itemBuilder: (context, index) {
                      return _buildInsumoCard(_insumos[index]);
                    },
                  ),
            const SizedBox(height: 20),
            const Text('Insumos Recomendados por Etapa:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ..._etapasPuerco.map((etapa) {
              final recomendaciones = _insumosRecomendados.where((insumo) => insumo.toLowerCase().contains(etapa.toLowerCase())).toList();
              if (recomendaciones.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$etapa:', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...recomendaciones.map((recomendacion) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('- $recomendacion'),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarInsumo,
        child: const Icon(Icons.add),
      ),
    );
  }
}