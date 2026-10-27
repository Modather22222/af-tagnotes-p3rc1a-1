import 'package:flutter/material.dart';

import 'note.dart';
import 'store.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, required this.store, this.note});

  final NotesStore store;
  final Note? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final TextEditingController _tagField;
  late final Set<String> _tags;

  bool get _isNew => widget.note == null;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _title = TextEditingController(text: note?.title ?? '');
    _body = TextEditingController(text: note?.body ?? '');
    _tagField = TextEditingController();
    _tags = Set.of(note?.tags ?? const <String>{});
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tagField.dispose();
    super.dispose();
  }

  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) {
      return;
    }
    setState(() {
      _tags.add(tag);
      _tagField.clear();
    });
  }

  void _save() {
    final title = _title.text.trim();
    final body = _body.text.trim();
    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a title or some text before saving.'),
        ),
      );
      return;
    }
    if (_isNew) {
      widget.store.addNote(title: title, body: body, tags: Set.of(_tags));
    } else {
      widget.store.updateNote(
        widget.note!.id,
        title: title,
        body: body,
        tags: Set.of(_tags),
      );
    }
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final note = widget.note;
    if (note == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text(
          '"${note.title.isEmpty ? 'Untitled' : note.title}" will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.store.deleteNote(note.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New note' : 'Edit note'),
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete note',
              onPressed: _delete,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save note',
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            style: theme.textTheme.titleLarge,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _body,
            minLines: 8,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Note text',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text('Tags', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in _tags.toList()..sort())
                Chip(
                  avatar: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: tagColor(tag),
                      shape: BoxShape.circle,
                    ),
                  ),
                  label: Text(tag),
                  onDeleted: () => setState(() => _tags.remove(tag)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tagField,
            onSubmitted: _addTag,
            decoration: InputDecoration(
              labelText: 'Add tag',
              hintText: 'e.g. work, ideas, errands',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add tag',
                onPressed: () => _addTag(_tagField.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
