import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cvdou/services/visionService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' hide MockClient;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


// Génère un mock
@GenerateMocks([http.Client])
import 'visionServiceTest.mocks.dart'; // IMPORTANT : ce fichier sera généré automatiquement
// Il faut lancer  flutter pub run build_runner build

Future<File> getImageFile() async {
  // URL de l'image en ligne
  final String imageUrl = 'https://fr.wikipedia.org/static/images/icons/wikipedia.png';

  // Télécharger l'image à partir de l'URL
  final http.Response response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final Uint8List imageBytes = response.bodyBytes;

    // Convertir les bytes en fichier temporaire
    final File testImage = File('${Directory.systemTemp.path}/online_image.png');
    await testImage.writeAsBytes(imageBytes);

    return testImage;
  } else {
    throw Exception('Impossible de télécharger l\'image depuis $imageUrl');
  }
}


void main() {
  group('VisionService', () {
    late VisionService visionService;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      visionService = VisionService('fake_api_key', mockHttpClient); // Injecter le mock
    });

    test('analyseImage retourne les données de l\'API en cas de succès', () async {
      // Simuler une réponse réussie de l'API
      final fakeResponse = {
        "responses": [
          {
            "labelAnnotations": [
              {"description": "cat", "score": 0.95},
              {"description": "animal", "score": 0.90},
            ],
            "webDetection": {
              "fullMatchingImages": [{"url": "https://example.com/cat.jpg"}],
              "partialMatchingImages": [{"url": "https://example.com/cat2.jpg"}],
            },
          }
        ]
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 200));


      // Obtenir un fichier image temporaire
      final File testImage = await getImageFile();

      // Appeler la méthode à tester avec le fichier image
      final result = await visionService.analyseImage(testImage);

      // Vérifier les résultats
      expect(result, isNotNull);
      expect(result, equals(fakeResponse));

      // Supprimer le fichier temporaire après le test
      await testImage.delete();
    });

    test('analyseImage retourne null en cas d\'erreur de l\'API', () async {
      // Simuler une réponse d'erreur de l'API
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Erreur interne du serveur', 500));

      // Obtenir un fichier image temporaire
      final File testImage = await getImageFile();

      // Appeler la méthode à tester avec le fichier image
      final result = await visionService.analyseImage(testImage);

      // Vérifier les résultats
      expect(result, isNull);

      // Supprimer le fichier temporaire après le test
      await testImage.delete();
    });

    test('extractUrlImages extrait correctement les URLs des images', () {
      // Données simulées de l'API
      final fakeResponse = {
        "responses": [
          {
            "webDetection": {
              "fullMatchingImages": [{"url": "https://example.com/cat.jpg"}],
              "partialMatchingImages": [{"url": "https://example.com/cat2.jpg"}],
            },
          }
        ]
      };

      // Appeler la méthode à tester
      final urls = visionService.extractUrlImages(fakeResponse);

      // Vérifier les résultats
      expect(urls, isNotEmpty);
      expect(urls, contains("https://example.com/cat.jpg"));
      expect(urls, contains("https://example.com/cat2.jpg"));
    });
  });
}