import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class InputImage extends StatefulWidget {
  final Function onSelectImage;

  const InputImage({Key key, this.onSelectImage}) : super(key: key);
  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  File _selectedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      widget.onSelectImage(imageFile);
      setState(() => _selectedImage = imageFile);
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    } else
      print('No image captured!!');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 90.0,
          width: 90.0,
          margin: const EdgeInsets.only(
            left: 8.0,
            top: 8.0,
            bottom: 8.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600]),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            clipBehavior: Clip.antiAlias,
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            wasSynchronouslyLoaded
                                ? child
                                : AnimatedOpacity(
                                    child: child,
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeOut,
                                  ),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.image_rounded)),
          ),
        ),
        TextButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.add_a_photo_rounded),
          label: Text('Take Picture'),
        ),
      ],
    );
  }
}
