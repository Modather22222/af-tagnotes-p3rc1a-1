import 'package:flutter/foundation.dart';

import 'note.dart';

class NotesStore extends ChangeNotifier {
  NotesStore() {
    final now = DateTime.now();
    _notes.addAll([
      Note(
        id: _nextId(),
        title: 'Welcome to TagNotes',
        body: 'Create notes, tag them with colors, then search or filter by tag. '
            'Everything lives in memory for this MVP.',
        tags: {'info'},
        updated: now,
      ),
      Note(
        id: _nextId(),
        title: 'Groceries',
        body: 'Oat milk, coffee beans, tomatoes, basil, olive oil.',
        tags: {'errands'},
        updated: now.subtract(const Duration(hours: 2)),
      ),
      Note(
        id: _nextId(),
        title: 'App ideas',
        body: 'Pomodoro timer, habit tracker, recipe box with pantry search.',
        tags: {'ideas', 'someday'},
        updated: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  final List<Note> _notes = [];
  final Set<String> _selectedTags = {};
  String _query = '';
  int _idCounter = 0;

  String _nextId() => 'note-${_idCounter++}';

  String get query => _query;
  Set<String> get selectedTags => Set.unmodifiable(_selectedTags);
  List<Note> get allNotes => List.unmodifiable(_notes);
  bool get isEmpty => _notes.isEmpty;

  List<Note> get visibleNotes {
    final filtered = _notes
        .where(
          (note) => note.matches(_query) && note.hasAllTags(_selectedTags),
        )
        .toList();
    filtered.sort((a, b) => b.updated.compareTo(a.updated));
    return List.unmodifiable(filtered);
  }

  List<String> get allTags {
    final tags = <String>{};
    for (final note in _notes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  bool isTagSelected(String tag) => _selectedTags.contains(tag);

  void setQuery(String value) {
    if (_query == value) {
      return;
    }
    _query = value;
    notifyListeners();
  }

  void toggleTagFilter(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  void clearFilters() {
    if (_selectedTags.isEmpty && _query.isEmpty) {
      return;
    }
    _selectedTags.clear();
    _query = '';
    notifyListeners();
  }

  Note addNote({
    required String title,
    required String body,
    required Set<String> tags,
  }) {
    final note = Note(
      id: _nextId(),
      title: title,
      body: body,
      tags: tags,
      updated: DateTime.now(),
    );
    _notes.add(note);
    notifyListeners();
    return note;
  }

  void updateNote(
    String id, {
    required String title,
    required String body,
    required Set<String> tags,
  }) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index == -1) {
      return;
    }
    _notes[index] = _notes[index].copyWith(
      title: title,
      body: body,
      tags: tags,
      updated: DateTime.now(),
    );
    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _selectedTags.removeWhere((tag) => !allTags.contains(tag));
    notifyListeners();
  }
}
