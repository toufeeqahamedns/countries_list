import 'package:countries_list/countries_model.dart';
import 'package:flutter/material.dart';

class CountriesListItem extends StatefulWidget {
  const CountriesListItem(
      {Key key, @required this.country, @required this.isFavoritesPage})
      : super(key: key);

  final bool isFavoritesPage;
  final Countries country;

  @override
  _CountriesListItemState createState() => _CountriesListItemState();
}

class _CountriesListItemState extends State<CountriesListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.country.country),
      subtitle: Text("${widget.country.code} | ${widget.country.region}"),
      trailing: Offstage(
        offstage: widget.isFavoritesPage,
        child: IconButton(
          icon: Icon(
            Icons.favorite,
            color: widget.country.isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              widget.country.isFavorite = true;
            });
          },
        ),
      ),
    );
  }
}
