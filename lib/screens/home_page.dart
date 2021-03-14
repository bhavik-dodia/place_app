import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_data.dart';
import 'add_place_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Places')),
      body: FutureBuilder(
        future: Provider.of<PlacesData>(context, listen: false).fetchPlaces(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Text('Nothing to see here')
                : Consumer<PlacesData>(
                    builder: (context, placesData, child) {
                      final places = placesData.places;
                      return places.isEmpty
                          ? child
                          : ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(place.image),
                                  ),
                                  title: Text(place.title),
                                  subtitle: Text(place.location.address),
                                );
                              },
                            );
                    },
                    child: const Text('Nothing to see here'),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        heroTag: 'add-place-fab',
        onPressed: () =>
            Navigator.of(context).pushNamed(AddPlacePage.routeName),
      ),
    );
  }
}
