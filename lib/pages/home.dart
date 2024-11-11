import 'package:flutter/material.dart';
import 'package:cvdou/widgets/home/customAppBar.dart';
import 'package:cvdou/widgets/home/customImagePickerWidget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(),
        body: Center(
          child: CustomImagePickerWidget(),
        )
    );
  }


}