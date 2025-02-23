import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cvdou/widgets/home/customImagePicker.dart';
import '../MaterialAppWidgetConst.dart';

Future<File> getImageFile(WidgetTester tester) async {
  // URL de l'image en ligne
  final String imageUrl = 'https://fr.wikipedia.org/static/images/icons/wikipedia.png';

  // Télécharger l'image à partir de l'URL
  late Uint8List imageBytes;
  await tester.runAsync(() async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
    } else {
      throw Exception('Impossible de télécharger l\'image depuis $imageUrl');
    }
  });

  // Convertir les bytes en fichier temporaire
  final File testImage = File('${Directory.systemTemp.path}/online_image.png');
  await testImage.writeAsBytes(imageBytes);

  return testImage;
}

Future<void> takeScreenShot(WidgetTester tester, String screenshotName) async {
  //await tester.pump(Duration(seconds: 2));
  // Pause pour voir l'écran avant capture
  //await tester.pumpAndSettle();

  // Préparer la surface de rendu pour la capture d'écran
  final binding = IntegrationTestWidgetsFlutterBinding.instance;
  await binding.convertFlutterSurfaceToImage(); // <-- Préparer la surface

  // Capture d'écran
  await binding.takeScreenshot(screenshotName);
}

void testPictureCamera() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vérifier que CustomImagePicker est présent', (WidgetTester tester) async {
    await tester.pumpWidget(MATERIAL_APP_WIDGET_CONST);
    expect(find.byType(CustomImagePicker), findsOneWidget);

    final Finder takePictureButton = find.widgetWithText(ElevatedButton, "Prendre une photo");
    expect(takePictureButton, findsOneWidget);

    // Télécharger l'image
    File testImage = await getImageFile(tester);

    late CustomImagePickerState state;
    // Injecter l'image téléchargée dans le widget
    await tester.runAsync(() async {
      state = tester.state(find.byType(CustomImagePicker));
      state.setState(() {
        state.image = testImage; // Injecter l'image téléchargée
      });
    });

    // Attendre que l'image soit chargée
    await tester.pumpAndSettle();

    // Vérifier que l'image est affichée
    expect(find.byType(Image), findsOneWidget);

    // Vérifier que l'état du widget a été mis à jour
    expect(state.image, isNotNull);

    // Prendre une capture d'écran
    //await takeScreenShot(tester, 'screenshot_image_picker');

    await tester.pumpAndSettle();

    // Vérifier la présence des boutons
    final Finder filterButton = find.widgetWithText(ElevatedButton, "Filtrer");
    expect(filterButton, findsOneWidget);

    final Finder searchButton = find.widgetWithText(ElevatedButton, "Rechercher");
    expect(searchButton, findsOneWidget);

    // Supprimer le fichier temporaire
    await testImage.delete();
  });
}

void main() {
  testPictureCamera();
}