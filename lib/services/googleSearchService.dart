import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSearchService {
  final String _apiKey = 'AIzaSyCy2x2K-4dQJ5iPOq4EK-pib4GSbltHVxc';
  final String _cx = '303898d572aed4acc';

  Future<List<String>> searchRelatedImages(Map<String, dynamic> searchResult) async {
    List<String> keywords = _extractKeywords(searchResult);

    final query = keywords.join(" ");
    final searchUrl = Uri.parse('https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&searchType=image&key=$_apiKey');

    try {
      final response = await http.get(searchUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractImageUrls(data);
      } else {
        print('Erreur : ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur de requête : $e');
      return [];
    }
  }

  // Fonction pour extraire des mots-clés des résultats de `searchImage`
  List<String> _extractKeywords(Map<String, dynamic> searchResult) {
    final labelAnnotations = searchResult['responses'][0]['labelAnnotations'] ?? [];
    return labelAnnotations.map<String>((label) => label['description'] as String).toList();
  }

  // Fonction pour extraire les URL d'images de la réponse de recherche Google Custom Search
  List<String> _extractImageUrls(Map<String, dynamic> data) {
    final items = data['items'] ?? [];
    return items.map<String>((item) => item['link'] as String).toList();
  }


}
