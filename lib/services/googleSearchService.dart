import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cvdou/objects/imageResult.dart';

class GoogleSearchService {
  final String _apiKey = 'AIzaSyCy2x2K-4dQJ5iPOq4EK-pib4GSbltHVxc';
  final String _cx = '303898d572aed4acc';

  Future<List<ImageResult>> searchRelatedImages(Map<String, dynamic> searchResult) async {
    List<String> keywords = _extractKeywords(searchResult);
    final query = keywords.join(" ");
    final numResults = 10;

    List<ImageResult> allImages = [];

    int startIndex = 1;

    for (int i = 0; i < 3; i++) {
      final searchUrl = Uri.parse(
          'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&searchType=image&key=$_apiKey&num=$numResults&start=$startIndex'
      );

      try {
        final response = await http.get(searchUrl);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          allImages.addAll(_buildImages(data));

          startIndex += numResults;
        } else {
          print('Erreur : ${response.statusCode}');
          break;
        }
      } catch (e) {
        print('Erreur de requête : $e');
        break;
      }
    }

    return allImages;
  }


  List<String> _extractKeywords(Map<String, dynamic> searchResult) {
    // Extraire les labelAnnotations
    final labelAnnotations = searchResult['responses'][0]['labelAnnotations'] ?? [];

    // Extraire webDetection (contient bestGuessLabels et webEntities)
    final webDetection = searchResult['responses'][0]['webDetection'] ?? {};

    // Extraire les descriptions des labelAnnotations
    final labels = labelAnnotations.map<String>((label) => label['description'] as String).toList();

    // Extraire les bestGuessLabels
    final bestGuessLabels = webDetection['bestGuessLabels'] ?? [];
    final bestGuessDescriptions = bestGuessLabels.map<String>((label) => label['label'] as String).toList();

    // Extraire les descriptions des webEntities
    final webEntities = webDetection['webEntities'] ?? [];
    final webEntityDescriptions = webEntities.map<String>((entity) => entity['description'] as String).toList();

    // Fusionner toutes les descriptions dans l'ordre de priorité
    return [...bestGuessDescriptions, ...webEntityDescriptions, ...labels];
  }

  List<String> _extractImageUrls(Map<String, dynamic> data) {
    final items = data['items'] ?? [];
    return items.map<String>((item) => item['link'] as String).toList();
  }

  List<ImageResult> _buildImages(Map<String, dynamic> data) {
    final items = data['items'] ?? [];
    return items.map<ImageResult>((item) {
      final urlImage = item['link'] as String;
      final urlSource = item['source'] as String? ?? '';
      final price = item['price'] != null ? item['price'] as double : null;

      return ImageResult(urlImage, urlSource, price);
    }).toList();
  }


}
