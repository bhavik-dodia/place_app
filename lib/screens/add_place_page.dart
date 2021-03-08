import 'package:flutter/material.dart';

import '../widgets/input_image.dart';

class AddPlacePage extends StatefulWidget {
  static const routeName = 'add-place-page';
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Place')),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
          ),
          InputImage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Place'),
        icon: Icon(Icons.add_rounded),
        heroTag: 'add-place-fab',
        onPressed: () {},
      ),
    );
  }
}
