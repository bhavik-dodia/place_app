import 'dart:collection';

import 'package:flutter/foundation.dart';
import '../models/place.dart';

class PlacesData extends ChangeNotifier {
  List<Place> _places;

  UnmodifiableListView get places => UnmodifiableListView(_places);
}
