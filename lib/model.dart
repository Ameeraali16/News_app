class NewsArticle {
  final String title;
  final String publishedAt;
  final String? author;
  final String? imageUrl;
  final String description;
  final String content;
  final String url; // Add this field

  NewsArticle({
    required this.title,
    required this.publishedAt,
    this.author,
    this.imageUrl,
    required this.description,
    required this.content,
    required this.url, // Add this
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Add validation for required fields
    if (json['url'] == null) {
      throw ArgumentError('url is a required field and cannot be null.');
    }

    return NewsArticle(
      title: json['title'] ?? 'No title',
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      author: json['author'],
      imageUrl: processImageUrl(json['urlToImage']),
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'], // Required field
    );
  }

  static String? processImageUrl(String? url) {
    return url ?? ''; // Handle null URLs safely
  }
}
