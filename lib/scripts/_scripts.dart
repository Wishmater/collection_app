import 'dart:ui';
import 'package:collection_app/scripts/import_prnhb.dart';


final List<ScriptRegistration> registeredScripts = [
  const ScriptRegistration(
    name: 'Import Prnhb',
    callback: importPrnhb,
    description: 'Reimports the entire "Prnhb" collection, deleting existent '
        'and scanning files to infer items, tags and relations as best as possible',
  ),
];

class ScriptRegistration {
  final String name;
  final String description;
  final VoidCallback callback;

  const ScriptRegistration({
    required this.name,
    required this.description,
    required this.callback,
  });
}