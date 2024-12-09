import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cvdou/objects/imageResult.dart';
import 'package:cvdou/objects/websiteFilter.dart';

class GoogleSearchService {
  final String _apiKey;
  final String _cx;

  GoogleSearchService(this._apiKey, this._cx);

  Future<List<ImageResult>> searchRelatedImages(Map<String, dynamic> searchResult, List<WebsiteFilter> selectedFilters) async {
    print(selectedFilters);
    List<ImageResult> allImages = _buildImagesFromRelatedImages(searchResult);
    List<ImageResult> filteredImages;

    if(selectedFilters.isNotEmpty){
      filteredImages = allImages.where((image) {
        return selectedFilters.any((filter) => image.urlSource.contains(filter.url));
      }).toList();
    } else {
      filteredImages = allImages;
    }


    List<String> keywords = _extractKeywords(searchResult);

    final siteFilters = selectedFilters.isNotEmpty ? selectedFilters.map((filter) => "site:${filter.url}").join(" OR ") : '';
    String query = "${keywords.join(" ")} $siteFilters";
    final numResults = 10;

    print(query);

    List<ImageResult> searchedImages = await searchCustomSearch(query, numResults, 1);
    filteredImages.addAll(searchedImages);

    if(filteredImages.isEmpty && keywords.isNotEmpty){
      String fallBackQuery = keywords[0] + ' ' + siteFilters;
      print(fallBackQuery);

      searchedImages = await searchCustomSearch(fallBackQuery, numResults,1);

      if(searchedImages.isEmpty){
        fallBackQuery = fallBackQuery
            .replaceAll(RegExp(r'[^a-zA-Z0-9.\s:]'), '')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        print(fallBackQuery);
        searchedImages = await searchCustomSearch(fallBackQuery, numResults,1);
      }
      filteredImages.addAll(searchedImages);
    }

    return ImageResult.filterUniqueUrlSource(filteredImages);
  }

  Future<List<ImageResult>> searchCustomSearch(String query, int numResults, int startIndex) async {
    List<ImageResult> imagesResult = [];

    for (int i = 0; i < 3; i++) {
      // Construire l'URL de la requête
      final searchUrl = Uri.parse(
        'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&searchType=image&key=$_apiKey&num=$numResults&start=$startIndex',
      );

      try {
        // Envoyer la requête HTTP
        final response = await http.get(searchUrl);

        // Vérifier le statut HTTP
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Vérifier si des items sont présents
          final items = data['items'] ?? [];
          if (items.isEmpty) {
            print("Aucun résultat trouvé, sortie de la boucle.");
            break; // Sortir de la boucle si aucun résultat
          }

          // Ajouter les résultats à la liste
          final newImages = await _buildImages(data);
          imagesResult.addAll(newImages);

          // Mettre à jour l'index de départ
          startIndex += numResults;
        } else {
          print('Erreur HTTP : ${response.statusCode}');
          break; // Sortir en cas d'erreur de statut HTTP
        }
      } catch (e) {
        // Gérer les erreurs de requête
        print('Erreur de requête : $e');
        break; // Sortir en cas d'erreur pour éviter une boucle infinie
      }
    }

    // Retourner la liste des résultats
    return imagesResult;
  }




  List<String> _extractKeywords(Map<String, dynamic> searchResult) {
    // Extraire les labelAnnotations
    final labelAnnotations = searchResult['responses'][0]['labelAnnotations'] ?? [];

    // Extraire webDetection (contient bestGuessLabels et webEntities)
    final webDetection = searchResult['responses'][0]['webDetection'] ?? {};

    // Extraire les descriptions des labelAnnotations (limitées à 3)
    final labels = labelAnnotations
        .take(3)
        .map<String>((label) => label['description'] as String)
        .toList();

    // Extraire les bestGuessLabels (mettre entre guillemets)
    final bestGuessLabels = webDetection['bestGuessLabels'] ?? [];
    final bestGuessDescriptions = bestGuessLabels.isNotEmpty
        ? ['"${bestGuessLabels[0]['label']}"']
        : [];

    // Extraire les descriptions des webEntities (limitées à 1)
    final webEntities = webDetection['webEntities'] ?? [];
    final webEntityDescriptions = webEntities.isNotEmpty
        ? [webEntities[0]['description'] as String]
        : [];

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
      final urlSource = item['image']['contextLink'] as String;
      final price = item['product'] != null && item['product']['price'] != null ? item['product']['price'] as double : null;

      print(price);
      return ImageResult(urlImage, urlSource, price);
    }).toList();
  }

  List<ImageResult> _buildImagesFromRelatedImages(Map<String, dynamic> analysisResult) {
    List<ImageResult> images = [];

    // Extraire les labels détectés
    if (analysisResult['responses']?[0]['webDetection']?['fullMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['pagesWithMatchingImages']) {

        String source = image['url'];
        String urlImage;

        if (image['fullMatchingImages'] != null && image['fullMatchingImages'].isNotEmpty) {
          urlImage = image['fullMatchingImages'].first['url'];
        } else if (image['partialMatchingImages'] != null && image['partialMatchingImages'].isNotEmpty) {
          urlImage = image['partialMatchingImages'].first['url'];
        } else {
          urlImage = '';
        }
        images.add(ImageResult(urlImage, source, null));
      }
    }

    // Éliminer les doublons et retourner la liste des mots-clés
    return images.toSet().toList();
  }


}
