import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cvdou/services/visionService.dart';
import 'package:cvdou/widgets/home/searchBtn.dart';
import 'package:cvdou/widgets/home/imageGrid.dart';
import 'package:cvdou/services/googleSearchService.dart';
import 'package:cvdou/objects/imageResult.dart';
import 'package:cvdou/widgets/home/filterSearchBtn.dart';

class CustomImagePicker extends StatefulWidget {
  final List<ImageResult> imageResults;

  CustomImagePicker({Key? key, required this.imageResults}) : super(key: key);

  @override
  _CustomImagePickerState createState() =>
      _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final VisionService _visionService = VisionService();
  late List<ImageResult> _imageResults;
  final GoogleSearchService _googleSearchService = GoogleSearchService();
  bool _isLoading = false;
  List<String> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _imageResults = widget.imageResults;
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
        FilterSearchBtn(
          onFiltersSelected: (filters){
            setState(() {
              _selectedFilters = filters;
            });
          }
        ),
        SizedBox(height: 30),
        SearchBtn(
          onPressed: () async {
            setState(() {
              _imageResults.clear();
              _isLoading = true;
            });

            try {
              final analysis = await _visionService.analyseImage(_image!);
              final properFilters = _selectedFilters
                  .map((filter) => filter.toLowerCase().replaceAll(" ", ""))
                  .toList();

              List<ImageResult> imageResults = await _googleSearchService.searchRelatedImages(analysis!, properFilters);
              setState(() {
                _imageResults = imageResults;
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
            : _imageResults.isNotEmpty
            ? ImageGridWidget(images: _imageResults)
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image != null ? selectedImage() : unselectedImage();
  }
}
