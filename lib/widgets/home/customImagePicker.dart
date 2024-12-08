import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cvdou/services/visionService.dart';
import 'package:cvdou/widgets/home/searchBtn.dart';
import 'package:cvdou/widgets/home/imageGrid.dart';
import 'package:cvdou/services/googleSearchService.dart';
import 'package:cvdou/objects/imageResult.dart';
import 'package:cvdou/widgets/home/filterSearchBtn.dart';
import 'package:cvdou/objects/websiteFilter.dart';
import 'package:cvdou/objects/apiKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cvdou/constants/apiKeys.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cvdou/generated/l10n.dart';


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
  late VisionService _visionService;
  late List<ImageResult> _imageResults;
  late GoogleSearchService _googleSearchService;
  bool _isLoading = false;
  List<WebsiteFilter> _selectedFilters = [];
  List<ApiKey> _apiKeys = [];


  @override
  void initState() {
    super.initState();
    _imageResults = widget.imageResults;
    _initializeApiKeys();
  }

  Future<void> _initializeApiKeys() async {
    await _loadApiKeys();

    ApiKey? apiKeyVisionAi = ApiKey.getFromIdLib('googleVisionAi', _apiKeys);
    setState(() {
      _visionService = VisionService(apiKeyVisionAi != null ? apiKeyVisionAi.key : '');
    });

    ApiKey? apiKeyCS= ApiKey.getFromIdLib('googleCustomSearch', _apiKeys);
    ApiKey? apiKeyCx= ApiKey.getFromIdLib('googleCx', _apiKeys);

    setState(() {
      _googleSearchService = GoogleSearchService(
          apiKeyCS != null ? apiKeyCS.key : '',
          apiKeyCx != null ? apiKeyCx.key : ''
      );
    });

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
          child: Text(S.of(context).takePicture),
        ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: Text(S.of(context).chooseGallery),
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
          child: Text(S.of(context).takePicture),
        ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: Text(S.of(context).chooseGallery),
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

            if (_checkApiKeys()){
              return;
            }

            setState(() {
              _imageResults.clear();
              _isLoading = true;
            });

            try {
              await _initializeApiKeys();
              final analysis = await _visionService.analyseImage(_image!);

              List<ImageResult> imageResults = await _googleSearchService.searchRelatedImages(analysis!, _selectedFilters);
              setState(() {
                _imageResults = imageResults;
              });

              if (_imageResults.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(S.of(context).error),
                      content: Text(S.of(context).noResultInfo),
                    );
                  },
                );
                return; // Arrête l'exécution de onPressed
              }

            } catch (e) {
              print('Erreur : $e');

              if (_imageResults.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text( S.of(context).error),
                      content: Text(S.of(context).errorUserInfo),
                    );
                  },
                );
                return; // Arrête l'exécution de onPressed
              }

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



  bool _checkApiKeys(){
    bool checkShowDialog = false;
    for(var key in _apiKeys){
      if(key.key == ''){
        checkShowDialog = true;
        break;
      }
    }

    if(checkShowDialog){
      showDialog(
          context: context,
          builder: (BuildContext dialogContext)
          {
            return AlertDialog(
                title: Text(S.of(context).usageInformation),
                content:
                Text(S.of(context).usageInformationMessage)
            );
          }
      );
    }

    return checkShowDialog;
  }

  Future<void> _loadApiKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedApiKeys = prefs.getString('apiKeys');
    if (storedApiKeys != null) {
      List<dynamic> decodedKeys = jsonDecode(storedApiKeys);
      setState(() {
        _apiKeys = decodedKeys
            .map((key) => ApiKey(key['libId'], key['lib'], key['key']))
            .toList();
      });
    } else {
      setState(() {
        _apiKeys = basicApiKeys;
      });
    }
    print(_apiKeys);
  }
}
