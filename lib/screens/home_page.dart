import 'package:flutter/material.dart';

import 'add_place_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Places')),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        heroTag: 'add-place-fab',
        onPressed: () => Navigator.of(context).pushNamed(AddPlacePage.routeName),
      ),
    );
  }
}
