class Book {
  final String id;
  final String title;
  final String author;
  final int? publishYear;
  final String? genre;
  final String? isbn;
  final String? image;
  final String? status;
  final String? completeDate;
  final String? note;
  final String? updatedAt;
  final String? createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.publishYear,
    this.genre,
    this.isbn,
    this.image,
    this.status,
    this.completeDate,
    this.note,
    this.updatedAt,
    this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['_id'],
        title: json['title'],
        author: json['author'],
        publishYear: json['publishYear'],
        genre: json['genre'],
        isbn: json['isbn'],
        image: json['image'],
        note: json['note'],
        status: json['status'],
        completeDate: json['completeDate'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'publishYear': publishYear,
      'genre': genre,
      'isbn': isbn,
      'image': image ??
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/495px-No-Image-Placeholder.svg.png?20200912122019',
      'note': note,
      'status': status ?? 'Start',
      'completeDate': completeDate,
    };
  }
}
