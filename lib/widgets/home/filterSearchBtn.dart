import 'package:flutter/material.dart';
import 'package:cvdou/constants/webSitesFilter.dart';
import 'package:cvdou/objects/websiteFilter.dart';

class FilterSearchBtn extends StatefulWidget {
  final Function(List<WebsiteFilter>) onFiltersSelected;

  const FilterSearchBtn({Key? key, required this.onFiltersSelected})
      : super(key: key);

  @override
  State<FilterSearchBtn> createState() => _FilterSearchBtnState();
}

class _FilterSearchBtnState extends State<FilterSearchBtn> {
  final List<WebsiteFilter> _options = basicWebsiteFilters;

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
                  children: _options.map<Widget>((option) {
                    return CheckboxListTile(
                      title: Text(option.toString()),
                      value: option.isChecked,
                      onChanged: (bool? value) {
                        // Mettre à jour la valeur de la case cochée
                        setDialogState(() {
                          option.isChecked = value!;
                        });

                        // Envoyer immédiatement la liste des filtres sélectionnés
                        _updateFilters();
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
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour mettre à jour les filtres sélectionnés
  void _updateFilters() {
    final selectedFilters = _options
        .where((option) => option.isChecked == true)
        .toList();

    widget.onFiltersSelected(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showFilterDialog(context),
      child: const Text("Filtrer"),
    );
  }
}
