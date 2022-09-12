import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Variables
  File? imageFile;
  String firstButtonText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _getFromGallery();
              },
              child: const Text("Pick from gallery"),
            ),
            Container(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                _getFromCamera();
              },
              child: const Text("Pick from camera"),
            ),
            Container(
              child: imageFile == null
                  ? const SizedBox.shrink()
                  : Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton(
                              child: const Text('Save Image to Gallery'),
                              onPressed: () {
                                _saveImageToGallery();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            Text(firstButtonText),
          ],
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(pickedFile.path);
      });
    }
  }

  _saveImageToGallery() async {
    if (imageFile != null) {
      setState(() {
        firstButtonText = 'Saving in progress...';
      });

      //Remove duplicate extension - 13 Sep 2022
      //String fileExt = imageFile!.path.replaceAll(".jpg.jpg", ".jpg");

      await GallerySaver.saveImage(imageFile!.path, toDcim: true);

      setState(() {
        firstButtonText = 'Image saved!';
      });
    }
  }
}
