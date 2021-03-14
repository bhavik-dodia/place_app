import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/places_data.dart';
import '../widgets/input_image.dart';
import '../widgets/input_location.dart';

class AddPlacePage extends StatefulWidget {
  static const routeName = 'add-place-page';
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) => _pickedImage = pickedImage;

  Future<String> _getAddress(double lat, double long) async {
    final addresses = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(lat, long));
    final address = addresses.first.addressLine;
    return address;
  }

  void _selectPlace(double lat, double long) async =>
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: long,
        address: await _getAddress(lat, long),
      );

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) return;
    Provider.of<PlacesData>(context, listen: false).addPlace(
      Place(
        id: DateTime.now().toString(),
        title: _titleController.text,
        location: _pickedLocation,
        image: _pickedImage,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Place')),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              children: [
                Container(child: buildTopPart()),
                InputLocation(onSelectPlace: _selectPlace),
              ],
            )
          : Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.only(bottom: 65.0),
                  child: buildTopPart(),
                ),
                InputLocation(onSelectPlace: _selectPlace),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Place'),
        icon: Icon(Icons.add_rounded),
        heroTag: 'add-place-fab',
        onPressed: _savePlace,
      ),
    );
  }

  Column buildTopPart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 20.0),
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          controller: _titleController,
        ),
        InputImage(onSelectImage: _selectImage),
      ],
    );
  }
}
