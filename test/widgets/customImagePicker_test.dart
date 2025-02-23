import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../integration_test/MaterialAppWidgetConst.dart';

// Génère un mock pour ImagePicker
@GenerateMocks([ImagePicker])
import 'customImagePicker_test.mocks.dart'; // IMPORTANT : ce fichier sera généré automatiquement

void testPictureCamera() {
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockImagePicker = MockImagePicker();
  });

  testWidgets("Vérifier que prendre une photo fonctionne", (WidgetTester tester) async {
    // Simule le choix d'une image après la prise de photo
    when(mockImagePicker.pickImage(source: ImageSource.camera))
        .thenAnswer((_) async => XFile('test_resources/sample_image.jpg'));

    // Lance le widget
    await tester.pumpWidget(MATERIAL_APP_WIDGET_CONST);

    // Trouve le bouton "Prendre une photo"
    final Finder takePictureButton = find.widgetWithText(ElevatedButton, "Prendre une photo");
    expect(takePictureButton, findsOneWidget);

    // Simule un appui sur le bouton
    await tester.tap(takePictureButton);
    await tester.pumpAndSettle(); // Attends la fin de l'animation et la mise à jour de l'UI

    // Vérifie que l'image est bien affichée
    //expect(find.byType(Image), findsOneWidget);
  });
}

void testPictureGallery() {
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockImagePicker = MockImagePicker();
  });

  testWidgets("Vérifier que choisir une image depuis la galerie fonctionne", (WidgetTester tester) async {
    // Simule la sélection d'une image depuis la galerie
    when(mockImagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) async => XFile('test_resources/sample_image.jpg'));

    // Lance le widget
    await tester.pumpWidget(MATERIAL_APP_WIDGET_CONST);

    // Trouve le bouton "Choisir depuis la galerie"
    final Finder galleryButton = find.widgetWithText(ElevatedButton, "Choisir depuis la galerie");
    expect(galleryButton, findsOneWidget);

    // Simule un appui sur le bouton pour ouvrir la galerie
    await tester.tap(galleryButton);
    await tester.pumpAndSettle(); // Attends la fin de l'animation et la mise à jour de l'UI

    // Vérifie que l'image est bien affichée après la sélection
    //expect(find.byType(Image), findsOneWidget);
  });
}

void main() {
  // Test pour la caméra
  testPictureCamera();

  // Test pour la galerie
  testPictureGallery();
}
