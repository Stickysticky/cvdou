import 'package:cvdou/widgets/home/customImagePicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:cvdou/main.dart';
import 'package:cvdou/pages/home.dart';

import '../MaterialAppWidgetConst.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vérifier que CustomImagePicker est présent', (WidgetTester tester) async {
    //await tester.pumpWidget(MaterialApp(home: Home()));
    await tester.pumpWidget(MATERIAL_APP_WIDGET_CONST);
    await tester.pump(const Duration(seconds: 3)); // Pause de 2 secondes
    expect(find.byType(CustomImagePicker), findsOneWidget);
  });
}
