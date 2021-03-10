import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class InputLocation extends StatefulWidget {
  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  bool _isLocationSelected = false;
  LocationData locData;

  Future<void> _getLocation() async {
    locData = await Location().getLocation();
    setState(() => _isLocationSelected = true);
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
                  borderRadius: BorderRadius.circular(15.0),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(locData.latitude, locData.longitude),
                      zoom: 13.0,
                    ),
                    layers: [
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(locData.latitude, locData.longitude),
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
                      indent: 10,
                      endIndent: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {},
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
