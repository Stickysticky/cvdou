import 'package:flutter/material.dart';
import 'package:cvdou/widgets/common/customAppBar.dart';
import 'package:cvdou/constants/webSitesFilter.dart';
import 'package:cvdou/objects/websiteFilter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<WebsiteFilter> _websiteFilters = basicWebsiteFilters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la page
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 10.0),
            child: Text(
              "Filtrage",
              style: TextStyle(fontSize: 30),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 10.0),
            child: Text(
              "Clées API",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
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
                  // Mettre à jour les valeurs du filtre
                  websiteFilter.lib = libController.text;
                  websiteFilter.url = urlController.text;
                });
                Navigator.of(dialogContext).pop(); // Fermer le dialogue après sauvegarde
              },
              child: Text("Sauvegarder"),
            ),
          ],
        );
      },
    );
  }
}
