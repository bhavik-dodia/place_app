import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../models/place.dart';

class PlaceDetailsPage extends StatelessWidget {
  final Place place;
  const PlaceDetailsPage({Key key, this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: place.title + place.id,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              place.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              children: [
                buildImage(16 / 9),
                buildMap(),
              ],
            )
          : Row(
              children: [
                buildImage(4 / 3),
                buildMap(),
              ],
            ),
    );
  }

  Expanded buildMap() {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(
                  place.location.latitude,
                  place.location.longitude,
                ),
              ),
              layers: [
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        place.location.latitude,
                        place.location.longitude,
                      ),
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
          ),
          footer: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(8.0),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Hero(
                tag: place.location.address + place.id,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(double aspectRatio) {
    return Hero(
      tag: place.image.path + place.id,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
