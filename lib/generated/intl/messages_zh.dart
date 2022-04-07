// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "balance": MessageLookupByLibrary.simpleMessage("損益"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "click_plus_to_add_stock":
            MessageLookupByLibrary.simpleMessage("點選 + 新增自選股"),
        "delete": MessageLookupByLibrary.simpleMessage("刪除"),
        "delete_all_pick_stock":
            MessageLookupByLibrary.simpleMessage("刪除全部自選股"),
        "delete_all_pick_stock_confirm":
            MessageLookupByLibrary.simpleMessage("確定刪除全部自選股嗎？"),
        "no_pick_stock": MessageLookupByLibrary.simpleMessage("沒有自選股"),
        "pick_stock": MessageLookupByLibrary.simpleMessage("自選股"),
        "search": MessageLookupByLibrary.simpleMessage("搜尋"),
        "settings": MessageLookupByLibrary.simpleMessage("設定"),
        "stock_number": MessageLookupByLibrary.simpleMessage("股票代號"),
        "strategy": MessageLookupByLibrary.simpleMessage("策略選股"),
        "targets": MessageLookupByLibrary.simpleMessage("交易目標"),
        "tse": MessageLookupByLibrary.simpleMessage("加權指數")
      };
}
