import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import '../models/note.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  late Database _db;
  final _store = stringMapStoreFactory.store('notes');

  Future<void> init() async {
    _db = await databaseFactoryWeb.openDatabase('notes_db');
  }

  Future<List<Note>> getNotes() async {
    final records = await _store.find(_db);
    return records.map((r) => Note.fromMap(r.value)).toList();
  }

  Future<void> addNote(Note note) async {
    await _store.record(note.id).put(_db, note.toMap());
  }

  Future<void> updateNote(Note note) async {
    await _store.record(note.id).put(_db, note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _store.record(id).delete(_db);
  }
}
