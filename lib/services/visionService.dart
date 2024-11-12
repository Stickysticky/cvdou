// lib/services/vision_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VisionService {
  final String apiKey = 'AIzaSyCy2x2K-4dQJ5iPOq4EK-pib4GSbltHVxc';

  // Méthode pour analyser une image avec des types de détection par défaut
  Future<Map<String, dynamic>?> analyzeImage(File imageFile) async {
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    // Convertir l'image en Base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Construire la requête JSON avec les features par défaut
    final requestBody = jsonEncode({
      "requests": [
        {
          "image": {
            "content": base64Image,
          },
          "features": [
            { "type": "LABEL_DETECTION", "maxResults": 5 },
            { "type": "WEB_DETECTION", "maxResults": 5 },
            { "type": "LANDMARK_DETECTION", "maxResults": 1 },
            { "type": "OBJECT_LOCALIZATION" }
          ]
        }
      ]
    });

    try {
      final response = await http.post(
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
}
