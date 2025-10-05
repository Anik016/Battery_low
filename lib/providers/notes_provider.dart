import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../db/db_helper.dart';
import 'package:uuid/uuid.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<Note>> {
  final _db = DBHelper();
  final _uuid = const Uuid();

  NotesNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    await _db.init();
    state = await _db.getNotes();
  }

  Future<void> addNote(Note note) async {
    final newNote = Note(
      id: _uuid.v4(),
      title: note.title,
      content: note.content,
    );
    await _db.addNote(newNote);
    state = [...state, newNote];
  }

  Future<void> updateNote(Note note) async {
    await _db.updateNote(note);
    state = state.map((n) => n.id == note.id ? note : n).toList();
  }

  Future<void> deleteNote(String id) async {
    await _db.deleteNote(id);
    state = state.where((n) => n.id != id).toList();
  }
}
