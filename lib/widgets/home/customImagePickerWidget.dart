import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cvdou/services/visionService.dart';

class CustomImagePickerWidget extends StatefulWidget {
  @override
  _CustomImagePickerWidgetState createState() => _CustomImagePickerWidgetState();
}

class _CustomImagePickerWidgetState extends State<CustomImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final VisionService _visionService = VisionService();

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

  Future<void> _analyzeImage() async {
    final analysis = await _visionService.analyzeImage(_image!);
    print(analysis);
    List<String> urlImages = await _visionService.extractUrlImages(analysis!);
    print(urlImages);
  }

  Column unselectedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
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
        ElevatedButton(
          onPressed: _analyzeImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue.shade600,
          ),
          child: Text(
            "Rechercher",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image != null ? selectedImage() : unselectedImage();
  }
}
