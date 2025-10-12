class News {
  final int id;
  final String title;
  final String by;
  final int score;
  final String? url;
  final int time;
  final String? text;     // story or comment text
  final List<int>? kids;  // list of comment IDs

  News({
    required this.id,
    required this.title,
    required this.by,
    required this.score,
    required this.time,
    this.url,
    this.text,
    this.kids,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      by: json['by'] ?? 'Unknown',
      score: json['score'] ?? 0,
      time: json['time'] ?? 0,
      url: json['url'],
      text: json['text'],
      kids: json['kids'] != null
          ? List<int>.from(json['kids'].map((x) => x as int))
          : null,
    );
  }
}
