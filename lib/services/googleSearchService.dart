import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cvdou/objects/imageResult.dart';
import 'package:cvdou/objects/websiteFilter.dart';
import 'package:cvdou/constants/webSitesFilter.dart';

class GoogleSearchService {
  final String _apiKey = 'AIzaSyCy2x2K-4dQJ5iPOq4EK-pib4GSbltHVxc';
  final String _cx = '303898d572aed4acc';

  Future<List<ImageResult>> searchRelatedImages(Map<String, dynamic> searchResult, List<WebsiteFilter> selectedFilters) async {
    print(selectedFilters);
    List<ImageResult> allImages = _buildImagesFromRelatedImages(searchResult);

    List<ImageResult> filteredImages = allImages.where((image) {
      return basicWebsiteFilters.any((filter) => image.urlImage.contains(filter.url));
    }).toList();

    List<String> keywords = _extractKeywords(searchResult);

    final siteFilters = selectedFilters.map((filter) => "site:${filter.url}").join(" OR ");
    final query = "${keywords.join(" ")} $siteFilters";
    print (query);
    final numResults = 10;

    int startIndex = 1;

    for (int i = 0; i < 3; i++) {
      final searchUrl = Uri.parse(
          'https://www.googleapis.com/customsearch/v1?q=$query&cx=$_cx&searchType=image&key=$_apiKey&num=$numResults&start=$startIndex'
      );

      try {
        final response = await http.get(searchUrl);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Vérifier si des résultats sont présents
          final items = data['items'] ?? [];
          if (items.isEmpty) {
            print("Aucun résultat, sortie de la boucle.");
            break; // Sortir de la boucle si aucun résultat
          }

          // Ajouter les résultats
          filteredImages.addAll(_buildImages(data));
          startIndex += numResults;
        } else {
          print('Erreur : ${response.statusCode}');
          break; // Sortir en cas d'erreur de statut HTTP
        }
      } catch (e) {
        print('Erreur de requête : $e');
        break; // Sortir en cas d'erreur
      }
    }


    return filteredImages;
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
      for (var image in analysisResult['responses']?[0]['webDetection']?['fullMatchingImages']) {
        if (image['url'] != null) {
          images.add(ImageResult(image['url'], '', null));
        }
      }
    }

    if (analysisResult['responses']?[0]['webDetection']?['partialMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['partialMatchingImages']) {
        if (image['url'] != null) {
          images.add(ImageResult(image['url'], '', null));
        }
      }
    }

    if (analysisResult['responses']?[0]['webDetection']?['partialMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['partialMatchingImages']) {
        if (image['url'] != null) {
          images.add(ImageResult(image['url'], '', null));
        }
      }
    }

    // Éliminer les doublons et retourner la liste des mots-clés
    return images.toSet().toList();
  }


}
