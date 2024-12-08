import 'package:flutter/material.dart';
import 'package:cvdou/widgets/common/customAppBar.dart';
import 'package:cvdou/constants/webSitesFilter.dart';
import 'package:cvdou/objects/websiteFilter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cvdou/constants/apiKeys.dart';
import 'package:cvdou/objects/apiKey.dart';
import 'package:cvdou/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<WebsiteFilter> _websiteFilters = [];
  List<ApiKey> _apiKeys = basicApiKeys;
  Locale _locale = Locale('fr');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWebsiteFilters();
    _loadApiKeys();
  }

  Future<void> _loadApiKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedApiKeys = prefs.getString('apiKeys');
    if (storedApiKeys != null) {
      List<dynamic> decodedKeys = jsonDecode(storedApiKeys);
      setState(() {
        _apiKeys = decodedKeys
            .map((key) => ApiKey(key['libId'], key['lib'], key['key']))
            .toList();
      });
    } else {
      setState(() {
        _apiKeys = basicApiKeys;
      });
    }
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
        _websiteFilters = basicWebsiteFilters;
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

  Future<void> _saveApiKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> keysToSave = _apiKeys
        .map((apiKey) => {
      'libId': apiKey.libId,
      'lib': apiKey.lib,
      'key': apiKey.key,
    })
        .toList();
    await prefs.setString('apiKeys', jsonEncode(keysToSave));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne avec le titre et le FloatingActionButton
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).filtering,
                    style: TextStyle(fontSize: 30),
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: _addWebsiteFilter,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Liste des éléments avec icône modification
              ListView.builder(
                itemCount: _websiteFilters.length,
                shrinkWrap: true, // Empêcher la ListView de prendre tout l'espace
                physics: NeverScrollableScrollPhysics(), // Désactiver le défilement interne
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
              SizedBox(height: 30),
              Text(
                S.of(context).apiKeys,
                style: TextStyle(fontSize: 30),
              ),
              /*Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  S.of(context).updateKeysInfo,
                  style: TextStyle(fontSize: 15),
                ),
              ),*/
              SizedBox(height: 10),
              // Liste des clés API
              ListView.builder(
                itemCount: _apiKeys.length,
                shrinkWrap: true, // Empêcher la ListView de prendre tout l'espace
                physics: NeverScrollableScrollPhysics(), // Désactiver le défilement interne
                itemBuilder: (context, index) {

                  final apiKey = _apiKeys[index];

                  return ListTile(
                    title: Text(
                      apiKey.lib,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      apiKey.key,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editApiKeys(context, apiKey);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
          title: Text(S.of(context).addFilter),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: libController,
                decoration: InputDecoration(
                  labelText: S.of(context).nameFilter,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: S.of(context).urlFilter,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(S.of(context).cancel),
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
              child: Text(S.of(context).add),
            ),
          ],
        );
      },
    );
  }

  void _editApiKeys(BuildContext context, ApiKey apiKey){
    TextEditingController codeKeyController = TextEditingController(
      text: apiKey.key
    );
    
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(S.of(context).modifyKey),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  TextField(
                    controller: codeKeyController,
                    /*decoration: InputDecoration(
                      labelText: apiKey.key
                    ),*/
                  )
              ]
            ),
              actions: [
                TextButton(
                  onPressed: () {
                  Navigator.of(dialogContext).pop(); // Fermer le dialogue sans sauvegarde
                },
                child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      setState(() {
                        apiKey.key = codeKeyController.text;
                      });
                      _saveApiKeys();
                    });
                    Navigator.of(dialogContext).pop(); // Fermer le dialogue après sauvegarde
                  },
                  child: Text(S.of(context).save),
                ),
              ]
          );
        }
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
          title: Text(S.of(context).modifyFilter),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: libController,
                decoration: InputDecoration(
                  labelText: S.of(context).nameFilter,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: S.of(context).urlFilter,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialogue sans sauvegarde
              },
              child: Text(S.of(context).cancel),
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
              child: Text(S.of(context).save),
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
                S.of(context).delete,
                style: TextStyle(color: Colors.red), // Couleur rouge pour attirer l'attention
              ),
            ),
          ],
        );
      },
    );
  }

}
