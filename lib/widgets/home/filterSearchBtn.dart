import 'package:flutter/material.dart';

class FilterSearchBtn extends StatefulWidget {
  const FilterSearchBtn({super.key});

  @override
  State<FilterSearchBtn> createState() => _FilterSearchBtnState();
}

class _FilterSearchBtnState extends State<FilterSearchBtn> {
  // Liste des options à afficher
  final List<Map<String, dynamic>> _options = [
    {"label": "Option 1", "isChecked": false},
    {"label": "Option 2", "isChecked": false},
    {"label": "Option 3", "isChecked": false},
  ];

  // Fonction pour afficher la popup
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filtres"),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return Column(
                  children: _options.map((option) {
                    return CheckboxListTile(
                      title: Text(option['label']),
                      value: option['isChecked'],
                      onChanged: (bool? value) {
                        setDialogState(() {
                          option['isChecked'] = value!;
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la popup
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la popup
                print("Options sélectionnées : $_options");
              },
              child: const Text("Appliquer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showFilterDialog(context),
      child: const Text("Filtrer"),
    );
  }
}
