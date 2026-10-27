import 'package:flutter/material.dart';

@immutable
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.updated,
  });

  final String id;
  final String title;
  final String body;
  final Set<String> tags;
  final DateTime updated;

  Note copyWith({
    String? title,
    String? body,
    Set<String>? tags,
    DateTime? updated,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      updated: updated ?? this.updated,
    );
  }

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return true;
    }
    return title.toLowerCase().contains(q) ||
        body.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }

  bool hasAllTags(Set<String> selected) {
    if (selected.isEmpty) {
      return true;
    }
    return selected.every(tags.contains);
  }
}

const List<Color> tagPalette = [
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.brown,
];

Color tagColor(String tag) {
  var hash = 0;
  for (final codeUnit in tag.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  return tagPalette[hash % tagPalette.length];
}
