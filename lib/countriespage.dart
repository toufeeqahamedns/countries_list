import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:countries_list/bloc/countries_bloc.dart';
import 'package:countries_list/bloc/countries_event.dart';
import 'package:countries_list/bloc/countries_state.dart';
import 'package:countries_list/countrieslistitem.dart';
import 'package:countries_list/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesPage extends StatefulWidget {
  @override
  _CountriesPageState createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Country List"),
      ),
      body: BlocBuilder<CountriesBloc, CountriesState>(
          builder: (BuildContext context, CountriesState state) {
        switch (state.status) {
          case FetchStatus.networkFailure:
            return Center(
              child: Text("Its a Network failure"),
            );
          case FetchStatus.failure:
            return Center(
              child: Text("Its a failure"),
            );
          case FetchStatus.success:
            if (state.countries.isEmpty) {
              return const Center(child: Text('No posts'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.countries.length && !state.hasReachedMax
                    ? Loader()
                    : CountriesListItem(
                        country: state.countries[index],
                        isFavoritesPage: false,
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.countries.length
                  : state.countries.length + 1,
              controller: _scrollController,
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<CountriesBloc>().add(FetchCountries());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1.0);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        context.read<CountriesBloc>().add(FetchCountries());
        break;
      default:
        context.read<CountriesBloc>().add(NoConnection());
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
