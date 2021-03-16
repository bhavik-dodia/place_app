import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:place_app/helpers/channel_helper.dart';

class InputImage extends StatefulWidget {
  final Function onSelectImage;

  const InputImage({Key key, this.onSelectImage}) : super(key: key);
  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  Channel channel = Channel();
  File _selectedImage;

  _showPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(8.0),
        content: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('Take Picture'),
              onTap: () {
                Navigator.of(context).pop(true);
                // _selectPicture(ImageSource.camera);
              },
            ),
            Divider(indent: 15.0, endIndent: 15.0),
            ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text('From Gallery'),
              onTap: () {
                Navigator.of(context).pop(false);
                // _selectPicture(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectPicture() async {
    var isCamera = await _showPopup();
    if (isCamera == null && !isCamera is bool) {
      print('Nothing chosen');
      return;
    }
    final pickedImage = isCamera
        ? await channel.getImageFromCamera()
        : await channel.getImageFromGallery();
    if (pickedImage != null) {
      final imageFile = File(pickedImage);
      setState(() => _selectedImage = imageFile);
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    } else {
      print('No image selected!!');
    }
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
                    child: Icon(Icons.image_rounded),
                  ),
          ),
        ),
        TextButton.icon(
          onPressed: _selectPicture,
          icon: Icon(Icons.add_photo_alternate_rounded),
          label: Text('Insert an Image'),
        ),
      ],
    );
  }
}
