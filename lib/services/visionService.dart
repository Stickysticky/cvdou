import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VisionService {
  final String _apiKey;
  final http.Client _httpClient;

  // Injecter http.Client via le constructeur
  VisionService(this._apiKey, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>?> analyseImage(File imageFile) async {
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_apiKey');

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final requestBody = jsonEncode({
      "requests": [
        {
          "image": {
            "content": base64Image,
          },
          "features": [
            { "type": "LABEL_DETECTION", "maxResults": 100 },
            { "type": "WEB_DETECTION", "maxResults": 100 },
            { "type": "LANDMARK_DETECTION", "maxResults": 100 },
            { "type": "LOGO_DETECTION", "maxResults": 100 }
          ]
        }
      ]
    });
    try {
      final response = await _httpClient.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Erreur : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur de requête : $e');
      return null;
    }
  }

/*
  List<String> extractKeywords(Map<String, dynamic> analysisResult) {
    List<String> keywords = [];

    // Extraire les labels détectés
    if (analysisResult['responses']?[0]['labelAnnotations'] != null) {
      for (var label in analysisResult['responses'][0]['labelAnnotations']) {
        if (label['description'] != null) {
          keywords.add(label['description']);
        }
      }
    }

    // Extraire les entités Web détectées
    if (analysisResult['responses']?[0]['webDetection']?['webEntities'] != null) {
      for (var entity in analysisResult['responses'][0]['webDetection']['webEntities']) {
        if (entity['description'] != null) {
          keywords.add(entity['description']);
        }
      }
    }

    // Éliminer les doublons et retourner la liste des mots-clés
    return keywords.toSet().toList();
  }*/

  List<String> extractUrlImages(Map<String, dynamic> analysisResult) {
    List<String> urlImages = [];

    // Extraire les labels détectés
    if (analysisResult['responses']?[0]['webDetection']?['fullMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['fullMatchingImages']) {
        if (image['url'] != null) {
          urlImages.add(image['url']);
        }
      }
    }

    if (analysisResult['responses']?[0]['webDetection']?['partialMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['partialMatchingImages']) {
        if (image['url'] != null) {
          urlImages.add(image['url']);
        }
      }
    }

    if (analysisResult['responses']?[0]['webDetection']?['partialMatchingImages'] != null) {
      for (var image in analysisResult['responses']?[0]['webDetection']?['partialMatchingImages']) {
        if (image['url'] != null) {
          urlImages.add(image['url']);
        }
      }
    }

    // Éliminer les doublons et retourner la liste des mots-clés
    return urlImages.toSet().toList();
  }


/*
  Future<List<String>> analyzeImage(File image) async {
    final analysis = await searchImage(image);
    List<String> urlImages = await extractUrlImages(analysis!);
    print(urlImages);
    return urlImages;
  }*/

}
