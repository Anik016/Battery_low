import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class EditNotePage extends ConsumerStatefulWidget {
  final String? noteId;
  const EditNotePage({this.noteId, super.key});

  @override
  ConsumerState<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends ConsumerState<EditNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  Note? note;

  @override
  void initState() {
    super.initState();
    final notes = ref.read(notesProvider);
    note = widget.noteId != null && widget.noteId != 'new'
        ? notes.firstWhere((n) => n.id == widget.noteId)
        : null;
    titleController = TextEditingController(text: note?.title ?? '');
    contentController = TextEditingController(text: note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final notesNotifier = ref.read(notesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final newNote = Note(
                id: note?.id ?? '',
                title: titleController.text,
                content: contentController.text,
              );

              if (note == null) {
                await notesNotifier.addNote(newNote);
              } else {
                await notesNotifier.updateNote(newNote);
              }

              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
