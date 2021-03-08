import 'package:flutter/material.dart';

class InputImage extends StatefulWidget {
  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  var _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 65.0,
          width: 65.0,
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
                                ? CircularProgressIndicator.adaptive()
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
                    child: Text(
                      '😥',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.camera_rounded),
          label: Text('Take Picture'),
        ),
      ],
    );
  }
}
