import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cvdou/services/visionService.dart';
import 'package:cvdou/widgets/home/searchBtn.dart';
import 'package:cvdou/widgets/home/imageGrid.dart';
import 'package:cvdou/services/googleSearchService.dart';

class CustomImagePicker extends StatefulWidget {
  final List<String> urlImages;

  CustomImagePicker({Key? key, required this.urlImages}) : super(key: key);

  @override
  _CustomImagePickerState createState() =>
      _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final VisionService _visionService = VisionService();
  late List<String> _urlImages;
  final GoogleSearchService _googleSearchService = GoogleSearchService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _urlImages = widget.urlImages;
  }

  // Fonction pour ouvrir la caméra
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fonction pour ouvrir la galerie
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Column unselectedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 70),
        ElevatedButton(
          onPressed: _pickImageFromCamera,
          child: Text("Prendre une photo"),
        ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: Text("Choisir depuis la galerie"),
        ),
      ],
    );
  }

  Column selectedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.file(_image!),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pickImageFromCamera,
          child: Text("Prendre une photo"),
        ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: Text("Choisir depuis la galerie"),
        ),
        SizedBox(height: 30),
        SearchBtn(
          onPressed: () async {
            setState(() {
              _urlImages.clear();
              _isLoading = true;
            });

            try {
              final analysis = await _visionService.analyseImage(_image!);
              List<String> urlImages = await _googleSearchService.searchRelatedImages(analysis!);
              setState(() {
                _urlImages = urlImages; // Mettre à jour les URL d'images
              });
            } catch (e) {
              print('Erreur : $e');
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
        SizedBox(height: 20),
        _isLoading
            ? CircularProgressIndicator()
            : _urlImages.isNotEmpty
            ? ImageGridWidget(imageUrls: _urlImages)
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image != null ? selectedImage() : unselectedImage();
  }
}
