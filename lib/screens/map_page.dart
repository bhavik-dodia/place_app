import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _latlng = LatLng(15, 20);
  // MapController _mapController;

  // @override
  // void initState() {
  //   super.initState();
  //   _mapController = MapController();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick a place')),
      body: FlutterMap(
        // mapController: _mapController,
        options: MapOptions(
          center: LatLng(21.1534346, 72.8572711),
          onTap: (LatLng latlng) {
            setState(() => _latlng = latlng);
            // _mapController.onReady.then(
            //   (value) => _mapController.move(_latlng, 13.0),
            // );
          },
        ),
        layers: [
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _latlng,
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
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Select'),
        icon: Icon(Icons.check_rounded),
        heroTag: 'add-place-fab',
        onPressed: () {
          Navigator.of(context).pop(_latlng);
        },
      ),
    );
  }
}
