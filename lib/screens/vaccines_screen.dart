import 'package:appsigi5/models/vaccine_aplication.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/vaccine_card.dart';

class VaccinesScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const VaccinesScreen({super.key, required this.onThemeChanged});

  @override
  State<VaccinesScreen> createState() => _VaccinesScreenState();
}

class _VaccinesScreenState extends State<VaccinesScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<VaccineApplication>> _vaccineApplications = {};
  List<String> _recommendedVaccines = [
    'Hierro (al nacimiento)',
    'Diarrea Neonatal (7 días)',
    'Pleuroneumonía (3 semanas)',
    'Mal Rojo (8 semanas)',
  ];

  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _appliedByController = TextEditingController();
  final TextEditingController _pigIdentifierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVaccineApplications();
    _selectedDay = DateTime.now().subtract(const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));
  }

  List<VaccineApplication> _getApplicationsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);
    return _vaccineApplications[formattedDay] ?? [];
  }

  Future<void> _addVaccineApplication(String pigStage) async {
    if (_selectedDay != null && _vaccineNameController.text.isNotEmpty && _appliedByController.text.isNotEmpty && _pigIdentifierController.text.isNotEmpty) {
      final newApplication = VaccineApplication(
        vaccineName: _vaccineNameController.text,
        appliedBy: _appliedByController.text,
        pigIdentifier: _pigIdentifierController.text,
        pigStage: pigStage,
        applicationDate: DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day),
      );

      setState(() {
        final formattedDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
        _vaccineApplications.putIfAbsent(formattedDay, () => []);
        _vaccineApplications[formattedDay]!.add(newApplication);
        _vaccineNameController.clear();
        _appliedByController.clear();
        _pigIdentifierController.clear();
        _saveVaccineApplications();
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveVaccineApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = json.encode(_vaccineApplications.map((key, value) =>
        MapEntry(DateTime(key.year, key.month, key.day).toIso8601String(), value.map((app) => app.toJson()).toList())));
    await prefs.setString('vaccineApplications', encodedEvents);
  }

  Future<void> _loadVaccineApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEvents = prefs.getString('vaccineApplications');
    if (storedEvents != null) {
      final Map<String, dynamic> decodedEvents = json.decode(storedEvents);
      setState(() {
        _vaccineApplications = decodedEvents.map((key, value) => MapEntry(
            DateTime.parse(key), (value as List).map((item) => VaccineApplication.fromJson(item)).toList()));
      });
    }
  }

  Future<void> _deleteVaccineApplication(VaccineApplication applicationToDelete) async {
    setState(() {
      final formattedDay = DateTime(applicationToDelete.applicationDate.year, applicationToDelete.applicationDate.month, applicationToDelete.applicationDate.day);
      if (_vaccineApplications.containsKey(formattedDay)) {
        _vaccineApplications[formattedDay]!.remove(applicationToDelete);
        _saveVaccineApplications();
      }
    });
  }

  Future<void> _updateVaccineApplication(VaccineApplication oldApplication, String newVaccineName, String newAppliedBy, String newPigIdentifier, String newPigStage) async {
    setState(() {
      final formattedDay = DateTime(oldApplication.applicationDate.year, oldApplication.applicationDate.month, oldApplication.applicationDate.day);
      if (_vaccineApplications.containsKey(formattedDay)) {
        final index = _vaccineApplications[formattedDay]!.indexOf(oldApplication);
        if (index != -1) {
          _vaccineApplications[formattedDay]![index] = VaccineApplication(
            vaccineName: newVaccineName,
            appliedBy: newAppliedBy,
            pigIdentifier: newPigIdentifier,
            pigStage: newPigStage,
            applicationDate: oldApplication.applicationDate,
          );
          _saveVaccineApplications();
        }
      }
      _vaccineNameController.clear();
      _appliedByController.clear();
      _pigIdentifierController.clear();
      Navigator.of(context).pop();
    });
  }

  Future<void> _showAddVaccineDialog() async {
    String? selectedStage;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Aplicación de Vacuna'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _vaccineNameController,
                  decoration: const InputDecoration(labelText: 'Nombre de la vacuna'),
                ),
                TextField(
                  controller: _appliedByController,
                  decoration: const InputDecoration(labelText: 'Aplicada por'),
                ),
                TextField(
                  controller: _pigIdentifierController,
                  decoration: const InputDecoration(labelText: 'Identificador del cerdo'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Etapa del cerdo'),
                  value: selectedStage,
                  items: <String>['Lechón', 'Crecimiento', 'Engorde', 'Reproducción']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedStage = newValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona la etapa del cerdo';
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
                if (selectedStage != null && _vaccineNameController.text.isNotEmpty && _appliedByController.text.isNotEmpty && _pigIdentifierController.text.isNotEmpty) {
                  _addVaccineApplication(selectedStage!);
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

  Future<void> _showEditVaccineDialog(VaccineApplication applicationToEdit) async {
    _vaccineNameController.text = applicationToEdit.vaccineName;
    _appliedByController.text = applicationToEdit.appliedBy;
    _pigIdentifierController.text = applicationToEdit.pigIdentifier;
    String? selectedStage = applicationToEdit.pigStage;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Aplicación de Vacuna'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _vaccineNameController,
                  decoration: const InputDecoration(labelText: 'Nombre de la vacuna'),
                ),
                TextField(
                  controller: _appliedByController,
                  decoration: const InputDecoration(labelText: 'Aplicada por'),
                ),
                TextField(
                  controller: _pigIdentifierController,
                  decoration: const InputDecoration(labelText: 'Identificador del cerdo'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Etapa del cerdo'),
                  value: selectedStage,
                  items: <String>['Lechón', 'Crecimiento', 'Engorde', 'Reproducción']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedStage = newValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona la etapa del cerdo';
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
                if (selectedStage != null && _vaccineNameController.text.isNotEmpty && _appliedByController.text.isNotEmpty && _pigIdentifierController.text.isNotEmpty) {
                  _updateVaccineApplication(applicationToEdit, _vaccineNameController.text, _appliedByController.text, _pigIdentifierController.text, selectedStage!);
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacunas'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) => _getApplicationsForDay(day).map((app) => app.vaccineName).toList(),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade300),
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            events.length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Aplicaciones de vacuna para el día seleccionado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _selectedDay != null ? _showAddVaccineDialog : null,
                    child: const Text('Agregar Aplicación de Vacuna'),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedDay != null)
                    ..._getApplicationsForDay(_selectedDay!).map((app) => VaccineCard(
                          application: app,
                          onDelete: (deletedApp) {
                            _deleteVaccineApplication(deletedApp);
                          },
                          onEdit: (editedApp) {
                            _showEditVaccineDialog(editedApp);
                          },
                        )),
                  if (_selectedDay == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Selecciona un día para ver las aplicaciones de vacuna.'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vacunas Recomendadas por Etapa:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ..._recommendedVaccines.map((vaccine) => Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text('- $vaccine'),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}