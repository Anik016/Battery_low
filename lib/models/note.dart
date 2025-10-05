class Note {
  String id;
  String title;
  String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
      );
}
