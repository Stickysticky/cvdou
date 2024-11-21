import 'package:flutter/material.dart';
import 'package:cvdou/widgets/common/customAppBar.dart';
import 'package:cvdou/constants/webSitesFilter.dart';
import 'package:cvdou/objects/websiteFilter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<WebsiteFilter> _websiteFilters = [];

  @override
  void initState() {
    super.initState();
    _loadWebsiteFilters();
  }

  Future<void> _loadWebsiteFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFilters = prefs.getString('websiteFilters');
    if (storedFilters != null) {
      List<dynamic> decodedFilters = jsonDecode(storedFilters);
      setState(() {
        _websiteFilters = decodedFilters
            .map((filter) => WebsiteFilter(filter['lib'], filter['url'], filter['isChecked']))
            .toList();
      });
    } else {
      setState(() {
        _websiteFilters = basicWebsiteFilters; // Utiliser la liste par défaut
      });
    }
  }

  Future<void> _saveWebsiteFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> filtersToSave = _websiteFilters
        .map((filter) => {
      'lib': filter.lib,
      'url': filter.url,
      'isChecked': filter.isChecked,
    })
        .toList();
    await prefs.setString('websiteFilters', jsonEncode(filtersToSave));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne avec le titre et le FloatingActionButton
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filtrage",
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,15,0),
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _addWebsiteFilter,
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          // Liste des éléments avec icône modification
          Expanded(
            child: ListView.builder(
              itemCount: _websiteFilters.length,
              itemBuilder: (context, index) {
                final websiteFilter = _websiteFilters[index];
                return ListTile(
                  title: Text(
                    websiteFilter.lib,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    websiteFilter.url,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editWebsiteFilter(context, websiteFilter);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addWebsiteFilter() {
    // Ajouter un nouveau filtre
    TextEditingController libController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Ajouter un filtre"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: libController,
                decoration: InputDecoration(
                  labelText: "Nom du filtre",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: "URL du filtre",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialogue sans ajouter
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _websiteFilters.add(
                    WebsiteFilter(libController.text, urlController.text),
                  );
                  _saveWebsiteFilters(); // Sauvegarder les modifications
                });
                Navigator.of(dialogContext).pop(); // Fermer le dialogue après ajout
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _editWebsiteFilter(BuildContext context, WebsiteFilter websiteFilter) {
    // Contrôleurs pour les champs texte
    TextEditingController libController = TextEditingController(
      text: websiteFilter.lib,
    );
    TextEditingController urlController = TextEditingController(
      text: websiteFilter.url,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Modifier le filtre"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: libController,
                decoration: InputDecoration(
                  labelText: "Nom du filtre",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: "URL du filtre",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialogue sans sauvegarde
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  websiteFilter.lib = libController.text;
                  websiteFilter.url = urlController.text;
                  _saveWebsiteFilters(); // Sauvegarder les modifications
                });
                Navigator.of(dialogContext).pop(); // Fermer le dialogue après sauvegarde
              },
              child: Text("Sauvegarder"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _websiteFilters.remove(websiteFilter); // Supprimer l'élément
                  _saveWebsiteFilters(); // Sauvegarder les modifications
                });
                Navigator.of(dialogContext).pop(); // Fermer le dialogue après suppression
              },
              child: Text(
                "Supprimer",
                style: TextStyle(color: Colors.red), // Couleur rouge pour attirer l'attention
              ),
            ),
          ],
        );
      },
    );
  }

}
