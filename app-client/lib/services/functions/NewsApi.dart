import 'dart:convert';
import 'package:http/http.dart' as http;

// API Endpoint
String API_CALL =
    "https://newsdata.io/api/1/news?apikey=pub_6010996b71fa33f05394c9d61fe447273f6f4&q=madhya%20pradesh";

// List to store image URLs
List<String> imageUrls = [];

Future<bool> GetArticle() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(
      Uri.parse(API_CALL),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if 'results' exists and is a list
      if (responseBody.containsKey('results') &&
          responseBody['results'] is List) {
        List<dynamic> articles = responseBody['results'];

        // Clear the imageUrls list before populating it
        imageUrls.clear();

        // Iterate through articles and extract image URLs
        for (var article in articles) {
          String? imageUrl = article['image_url'] as String?;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            imageUrls.add(imageUrl); // Add valid image URLs to the list
          }
        }

        // Debug print to confirm stored image URLs
        print('Stored Image URLs: $imageUrls');

        return true;
      } else {
        print("No articles found in the response.");
        return false;
      }
    } else {
      print("API call failed with status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error fetching articles: $e");
    return false;
  }
}
