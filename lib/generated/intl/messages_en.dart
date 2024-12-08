// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addFilter": MessageLookupByLibrary.simpleMessage("Add a filter"),
        "apiKeys": MessageLookupByLibrary.simpleMessage("API keys"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotOpenLink":
            MessageLookupByLibrary.simpleMessage("Cannot open the link"),
        "chooseGallery":
            MessageLookupByLibrary.simpleMessage("Choose from gallery"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "errorUserInfo": MessageLookupByLibrary.simpleMessage(
            "An error occurred during the search. Please check your API keys and connection"),
        "filtering": MessageLookupByLibrary.simpleMessage("Filtering"),
        "modifyFilter": MessageLookupByLibrary.simpleMessage("Modify filter"),
        "modifyKey": MessageLookupByLibrary.simpleMessage("Modifiy key"),
        "nameFilter": MessageLookupByLibrary.simpleMessage("Filters name"),
        "noResultInfo":
            MessageLookupByLibrary.simpleMessage("No results found."),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "takePicture": MessageLookupByLibrary.simpleMessage("Take a picture"),
        "updateKeysInfo": MessageLookupByLibrary.simpleMessage(
            "Please restart the application after changing this information"),
        "urlFilter": MessageLookupByLibrary.simpleMessage("Filters url"),
        "usageInformation":
            MessageLookupByLibrary.simpleMessage("Use information"),
        "usageInformationMessage": MessageLookupByLibrary.simpleMessage(
            "This app uses Google Vision ai API and Google Custom Search. Please add your API keys in settings")
      };
}
