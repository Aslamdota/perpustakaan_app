class Book {
  final int? id;
  final String title;
  final String author;
  final int? year;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
    };
  }
}