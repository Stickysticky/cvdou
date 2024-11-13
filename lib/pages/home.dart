import 'package:flutter/material.dart';
import 'package:cvdou/widgets/home/customAppBar.dart';
import 'package:cvdou/widgets/home/customImagePicker.dart';
import 'package:cvdou/widgets/home/imageGrid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> _urlImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomImagePicker(urlImages: _urlImages),
              SizedBox(height: 20),
              _urlImages.isNotEmpty
                  ? ImageGridWidget(imageUrls: _urlImages)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

}