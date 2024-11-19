import 'package:flutter/material.dart';
import 'package:cvdou/widgets/common/customAppBar.dart';
import 'package:cvdou/widgets/home/customImagePicker.dart';
import 'package:cvdou/widgets/home/imageGrid.dart';
import 'package:cvdou/objects/imageResult.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<ImageResult> _imageResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomImagePicker(imageResults: _imageResults),
              SizedBox(height: 20),
              _imageResults.isNotEmpty
                  ? ImageGridWidget(images: _imageResults)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

}