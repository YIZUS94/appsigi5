import 'package:appsigi5/models/vaccine_aplication.dart';
import 'package:flutter/material.dart';


class VaccineCard extends StatelessWidget {
  final VaccineApplication application;
  final Function(VaccineApplication) onDelete;
  final Function(VaccineApplication) onEdit;

  const VaccineCard({
    super.key,
    required this.application,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vacuna: ${application.vaccineName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Aplicada por: ${application.appliedBy}'),
            Text('Cerdo: ${application.pigIdentifier}'),
            Text('Etapa: ${application.pigStage}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    onEdit(application);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDelete(application);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}