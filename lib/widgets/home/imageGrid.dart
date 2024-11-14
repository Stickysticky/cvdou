import 'package:flutter/material.dart';
import 'package:cvdou/objects/imageResult.dart';

class ImageGridWidget extends StatelessWidget {
  final List<ImageResult> images;

  ImageGridWidget({required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImagePopup(context, images[index].urlImage),
            child: Image.network(
              images[index].urlImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // L'image est prête
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.error));
              },
            ),
          );
        },
      ),
    );
  }

  void _showImagePopup(BuildContext context, String urlImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.network(
              urlImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.error)); // Afficher une icône d'erreur dans le popup
              },
            ),
          ),
        );
      },
    );
  }
}
