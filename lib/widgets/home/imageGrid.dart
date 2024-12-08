import 'package:flutter/material.dart';
import 'package:cvdou/objects/imageResult.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cvdou/generated/l10n.dart';

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
            onTap: () => _showImagePopup(context, images[index]),
            child: Image.network(
              images[index].urlImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
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

  void _showImagePopup(BuildContext context, ImageResult image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              // Image affichée en plein écran
              Container(
                padding: EdgeInsets.all(10),
                child: Image.network(
                  image.urlImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Icons.error));
                  },
                ),
              ),
              // Icône en haut à gauche pour rediriger vers l'URL
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Ferme le popup
                    _redirectToUrl(context, image.urlSource); // Redirige vers l'URL
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Fond semi-transparent
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _redirectToUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // Vérifiez si l'URL peut être ouverte
    if (await canLaunchUrl(uri)) {
      // Ouvre l'URL dans le navigateur
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Affiche un message d'erreur si l'URL ne peut pas être ouverte
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).cannotOpenLink),
        ),
      );
    }
  }
}
