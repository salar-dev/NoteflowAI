class Note {
  final int id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final List<String> photos;
  final String? imageTexts;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.photos,
    this.imageTexts,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['noteContent'],
      createdAt: DateTime.parse(map['created_at']),
      photos: List<String>.from(map['photos'] ?? []),
      imageTexts: map['imageTexts'],
    );
  }
}
