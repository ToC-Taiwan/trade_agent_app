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
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "click_plus_to_add_stock":
            MessageLookupByLibrary.simpleMessage("Click + to add stock"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_all_pick_stock":
            MessageLookupByLibrary.simpleMessage("Delete All Pick Stock"),
        "delete_all_pick_stock_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete all pick stock?"),
        "no_pick_stock": MessageLookupByLibrary.simpleMessage("No Pick Stock"),
        "pick_stock": MessageLookupByLibrary.simpleMessage("Pick Stock"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "stock_number": MessageLookupByLibrary.simpleMessage("Stock Number"),
        "strategy": MessageLookupByLibrary.simpleMessage("Strategy"),
        "targets": MessageLookupByLibrary.simpleMessage("Targets"),
        "tse": MessageLookupByLibrary.simpleMessage("TSE")
      };
}
