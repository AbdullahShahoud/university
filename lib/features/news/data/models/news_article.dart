class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String category;
  final String author;
  final String sourceCompany;
  final DateTime publishedAt;
  final int views;
  final List<String> tags;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.sourceCompany,
    required this.publishedAt,
    required this.views,
    required this.tags,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      author: json['author'] as String,
      sourceCompany: json['sourceCompany'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      views: (json['views'] as num).toInt(),
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'content': content,
    'imageUrl': imageUrl,
    'category': category,
    'author': author,
    'sourceCompany': sourceCompany,
    'publishedAt': publishedAt.toIso8601String(),
    'views': views,
    'tags': tags,
  };
}
