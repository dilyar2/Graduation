import 'package:flutter/material.dart';



class CustomCourseInfo extends StatelessWidget {
  final String title;
  final double price;
  final int watchCount;
  final double rating;
  final String img;

  const CustomCourseInfo({
    super.key,
    required this.title,
    required this.price,
    required this.watchCount,
    required this.rating,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (img.isNotEmpty)
            Image.network(
              img,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 160,
                child: Icon(Icons.image_not_supported),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Views: $watchCount  •  Rating: ${rating.toStringAsFixed(1)}  •  Price: ${price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
