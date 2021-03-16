import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import '../screens/map_page.dart';

class InputLocation extends StatefulWidget {
  final Function onSelectPlace;

  const InputLocation({Key key, this.onSelectPlace}) : super(key: key);
  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  bool _isLocationSelected = false;
  LatLng _latLng;
  MapController _mapController;
  Position _position;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _getLocation() async {
    try {
      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (error) {
      print(error);
      return;
    }
    setState(() {
      _latLng = LatLng(_position.latitude, _position.longitude);
      _isLocationSelected = true;
    });
    _mapController.onReady.then(
      (value) => _mapController.move(_latLng, 13.0),
    );
    widget.onSelectPlace(_position.latitude, _position.longitude);
  }

  void selectOnMap() async {
    final latLng = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (context) => MapPage()),
    );
    if (latLng == null) {
      return;
    } else {
      widget.onSelectPlace(latLng.latitude, latLng.longitude);
      setState(() {
        _latLng = latLng;
        _isLocationSelected = true;
      });
      _mapController.onReady.then(
        (value) => _mapController.move(_latLng, 13.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 75.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: GridTile(
          child: _isLocationSelected
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _latLng,
                    ),
                    layers: [
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _latLng,
                            builder: (ctx) => Icon(
                              Icons.location_on_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                    children: [
                      TileLayerWidget(
                        options: TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('No Location Chosen')),
          footer: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: _getLocation,
                      icon: Icon(Icons.location_on_rounded),
                      label: Text('Current Location'),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      indent: 8,
                      endIndent: 8,
                    ),
                    TextButton.icon(
                      onPressed: selectOnMap,
                      icon: Icon(Icons.map_rounded),
                      label: Text('Select on Map'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
