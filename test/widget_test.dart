import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagnotes/main.dart';

void main() {
  testWidgets('TagNotes renders the notes home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TagNotesApp());
    await tester.pump();

    expect(find.text('TagNotes'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Welcome to TagNotes'), findsOneWidget);
  });
}
