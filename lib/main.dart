import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'store.dart';

void main() {
  runApp(const TagNotesApp());
}

class TagNotesApp extends StatefulWidget {
  const TagNotesApp({super.key});

  @override
  State<TagNotesApp> createState() => _TagNotesAppState();
}

class _TagNotesAppState extends State<TagNotesApp> {
  final NotesStore _store = NotesStore();

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6750A4);
    return MaterialApp(
      title: 'TagNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: NotesHome(store: _store),
    );
  }
}
