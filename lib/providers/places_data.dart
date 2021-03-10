import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../databases/database.dart';
import '../models/place.dart';

class PlacesData extends ChangeNotifier {
  List<Place> _places = [];

  UnmodifiableListView get places => UnmodifiableListView(_places);

  Future<void> fetchPlaces() async {
    final dataList = await DataBase.getData('places');
    _places = dataList
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            image: File(e['image']),
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }

  void addPlace(Place place) {
    _places.add(place);
    notifyListeners();
    DataBase.insert(
      'places',
      {
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
      },
    );
  }
}
