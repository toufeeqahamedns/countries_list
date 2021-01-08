import 'package:countries_list/bloc/countries_bloc.dart';
import 'package:countries_list/countrieslistitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CountriesListItem(
              country: context
                  .watch<CountriesBloc>()
                  .state
                  .countries
                  .where((element) => element.isFavorite)
                  .elementAt(index), isFavoritesPage: true,);
        },
        itemCount: context
            .watch<CountriesBloc>()
            .state
            .countries
            .where((element) => element.isFavorite)
            .length,
      ),
    );
  }
}
