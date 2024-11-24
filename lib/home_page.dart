import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/Api.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);

  // Log the URL
  print('Launching URL: $url');

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Ensure external browser launch
      );
      print('Successfully launched URL.');
    } else {
      print('Cannot launch URL: $url');
    
    }
  } catch (e) {
    print('Error launching URL: $e');
   
  }
}

  
   Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10, // Number of shimmer items to show
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    width: 100,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  // Content placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                        ),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                        ),
                        Container(
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // Add this method to show the modal bottom sheet
  void _showArticleDetails(BuildContext context, NewsArticle article) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Image
              if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Title
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Date and Author Row
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(article.publishedAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (article.author != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        article.author!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Description
              if (article.description.isNotEmpty) ...[
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],

              // Content
              if (article.content.isNotEmpty) ...[
                const Text(
                  'Content',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.content,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const SizedBox(height: 24),

              // Read Full Article Button
              ElevatedButton(
                
                onPressed: () => _launchURL(article.url), 
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.launch),
                    SizedBox(width: 8),
                    Text(
                      'Read Full Article',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NewsBloc(NewsRepository())..add(FetchNews()),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Headline News",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Read Top News Today",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset(
                  "lib/world-news.png",
                  height: 27,
                  width: 27,
                ),
              )
            ],
          ),
          body: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return  _buildShimmerLoading();
              } else if (state is NewsLoaded) {
                final articles = state.articles;
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 15.0,
                      ),
                       child: InkWell( // Add this InkWell
                       onTap: () => _showArticleDetails(context, article),
      
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Image Section
                            SizedBox(
                              height: 80,
                              child: _buildImage(article.imageUrl),
                            ),
                            // Content Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatDate(article.publishedAt),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (article.description.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          article.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    );
                  },
                );
              } else if (state is NewsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }
              return const Center(child: Text("No news available"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
  print('Building image with URL: $imageUrl'); // Debug log

  if (imageUrl == null || imageUrl.isEmpty) {
    print('Image URL is null or empty'); // Debug log
    return _buildPlaceholder();
  }

  // Validate URL format
  try {
    final uri = Uri.parse(imageUrl);
    if (!uri.isScheme('HTTPS')) {
      print('Warning: URL is not HTTPS: $imageUrl'); // Debug log
    }
  } catch (e) {
    print('Invalid URL format: $imageUrl'); // Debug log
    return _buildPlaceholder();
  }

  const double boxSize = 120.0; // Define the fixed size for the square box

  return Container(
    width: boxSize,
    height: boxSize,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
    ),
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover, // Ensures the image covers the box
      placeholder: (context, url) {
        print('Loading image: $url'); // Debug log
        return Center(
          child: _buildShimmerLoadingimage(boxSize),
        );
      },
      errorWidget: (context, url, error) {
        print('Error loading image: $error for URL: $url'); // Debug log
        return _buildPlaceholder(boxSize);
      },
    ),
  );
}

 Widget _buildPlaceholder([double size = 100.0]) {
  return Container(
    width: size,
    height: size,
    color: Colors.grey[200],
    child: Center(
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 32,
      ),
    ),
  );
}

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
Widget _buildShimmerLoadingimage([double size = 100.0]) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: size,
      height: size,
      color: Colors.white,
    ),
  );
}

