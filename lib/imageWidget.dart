import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const NewsImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
  }) : super(key: key);

  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    // Check for common image file extensions
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final hasValidExtension = validExtensions.any((ext) => 
      url.toLowerCase().contains(ext));
    
    // Check if it's a valid HTTP/HTTPS URL
    return (url.startsWith('http://') || url.startsWith('https://')) && 
           hasValidExtension;
  }

  @override
  Widget build(BuildContext context) {
    // Validate URL before attempting to load
    if (!isValidImageUrl(imageUrl)) {
      print('Invalid or null image URL: $imageUrl');
      return buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      maxHeightDiskCache: 1500,
      memCacheWidth: 600,
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => buildLoadingPlaceholder(),
      errorWidget: (context, url, error) {
        print('Error loading image from URL: $url, Error: $error');
        return buildPlaceholder();
      },
    );
  }

  Widget buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: width * 0.5,
      ),
    );
  }
}