import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart'; 

class NewsRepository {

 final String baseUrl = "https://newsapi.org/v2/top-headlines";
  final String apiKey = "c793cfd0d47a4b609c983124bb6a1377";

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    try {
      final Uri uri = Uri.parse('$baseUrl?country=us&apiKey=$apiKey');
      
      print('Fetching from URL: $uri');
      
      final response = await http.get(uri);
      
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }
        
        if (!data.containsKey('articles')) {
          throw Exception('Invalid API response: missing articles key');
        }
        
        final List<dynamic> articles = data['articles'];
        
        return articles.map((article) {
          try {
            return NewsArticle.fromJson(article);
          } catch (e) {
            print('Error parsing article: $e');
            print('Problematic article data: $article');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching news: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}



// Future<List<NewsArticle>> fetchTopHeadlines() async {
//   await Future.delayed(Duration(seconds: 1)); // Simulate network delay

//   return [
//     NewsArticle(
//       title: "Breaking News: Flutter 3 Released!",
//       publishedAt: "2024-11-23",
//       author: "John Doe",
//       imageUrl: "https://via.placeholder.com/150", content: '', description: '',
//     ),
//     NewsArticle(
//       title: "Dart Gets Major Update with Exciting Features",
//       publishedAt: "2024-11-22",
//       author: "Jane Smith",
//       imageUrl: "https://via.placeholder.com/150", content: '', description: '',
//     ),
//   ];
//}
//}
