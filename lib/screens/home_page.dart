import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_data.dart';
import 'add_place_page.dart';
import 'place_details_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Places')),
      body: FutureBuilder(
        future: Provider.of<PlacesData>(context, listen: false).fetchPlaces(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? buildEmptyPage(context)
                : Consumer<PlacesData>(
                    builder: (context, placesData, child) {
                      final places = placesData.places;
                      return places.isEmpty
                          ? child
                          : ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return Card(
                                  elevation: 8.0,
                                  margin: const EdgeInsets.all(8.0),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    isThreeLine: true,
                                    leading: Hero(
                                      tag: place.image.path + place.id,
                                      child: CircleAvatar(
                                        minRadius: 20.0,
                                        maxRadius: 30.0,
                                        backgroundImage: FileImage(place.image),
                                      ),
                                    ),
                                    title: Hero(
                                      tag: place.title + place.id,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          place.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Hero(
                                      tag: place.location.address + place.id,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          place.location.address,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlaceDetailsPage(place: place),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                    child: buildEmptyPage(context),
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

  Flex buildEmptyPage(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset('images/explore_places.png'),
              ),
              const Text(
                'There are currently no places to explore',
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset('images/explore_places.png'),
              ),
              const Text(
                'There are currently no places to explore',
                textAlign: TextAlign.center,
              ),
            ],
          );
  }
}
