// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Ajouter"),
        "addFilter": MessageLookupByLibrary.simpleMessage("Ajouter un filtre"),
        "apiKeys": MessageLookupByLibrary.simpleMessage("Clées API"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "cannotOpenLink": MessageLookupByLibrary.simpleMessage(
            "Impossible d\'ouvrir le lien"),
        "chooseGallery":
            MessageLookupByLibrary.simpleMessage("Choisir depuis la galerie"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "error": MessageLookupByLibrary.simpleMessage("Erreur"),
        "errorUserInfo": MessageLookupByLibrary.simpleMessage(
            "Une erreur a eu lieu lors de la recherche. Veuillez vérifier vos clés API et votre connexion"),
        "filtering": MessageLookupByLibrary.simpleMessage("Filtrage"),
        "modifyFilter":
            MessageLookupByLibrary.simpleMessage("Modifier le filtre"),
        "modifyKey": MessageLookupByLibrary.simpleMessage("Modifier la clée"),
        "nameFilter": MessageLookupByLibrary.simpleMessage("Nom du filtre"),
        "noResultInfo": MessageLookupByLibrary.simpleMessage(
            "Aucun résultat n\'a été trouvé."),
        "save": MessageLookupByLibrary.simpleMessage("Sauvegarder"),
        "search": MessageLookupByLibrary.simpleMessage("Rechercher"),
        "takePicture":
            MessageLookupByLibrary.simpleMessage("Prendre une photo"),
        "updateKeysInfo": MessageLookupByLibrary.simpleMessage(
            "Veuillez redémarrer l\'application après la modification de ces informations"),
        "urlFilter": MessageLookupByLibrary.simpleMessage("Url du filtre"),
        "usageInformation":
            MessageLookupByLibrary.simpleMessage("Informations utilisation"),
        "usageInformationMessage": MessageLookupByLibrary.simpleMessage(
            "Cette application utilise l\'api Google Vision ai et Google Custom Search. Veuillez ajouter vos clés API dans les paramètres")
      };
}
